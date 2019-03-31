#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import os
import glob
import re
import sys
import json
import argparse
import itertools

def find_all_color_dirs(base):
    """ Find all the paths containing a 'color' directory """
    results = itertools.chain.from_iterable(glob.iglob(os.path.join(root, 'colors')) for root, dirs, files in os.walk(base))

    return list(results)

# TODO maybe replace with a dict?
class ColourScheme:
    def __init__(self, name='', path='', variants=[], defaultVariant=[], languagesGood=[], languagesBad=[], tags=[]):
        self.name = name

        # Relative to dotfiles!
        self.path = path

        self.variants = variants
        self.defaultVariant = defaultVariant

        # List of languages this is particularly good with
        self.languagesGood = languagesGood

        # List of languages this is particularly bad with
        self.languagesBad = languagesBad

        # Tags such as 'whitelist', 'blacklist', etc, anything
        self.tags = tags

class CSData:
    """ Basically the data structure we're going to read in and out of JSON """

    def __init__(self, path, colourSchemes = [], cachedWhitelist = [], cachedList=[]):
        self.path = path
        self.colourSchemes   = colourSchemes
        self.cachedWhitelist = cachedWhitelist
        self.cachedList      = cachedList

    def has(self, name):
        """ Check if we have a colourscheme by 'name' """
        return any(s.name == name for s in self.colourSchemes)

    def find(self, name):
        """ Check if we have a colourscheme by 'name' """
        for idx, s in enumerate(self.colourSchemes):
            if s.name == name:
                return idx

        return -1;

    @staticmethod
    def load(fname):
        """ Load in a cache file """
        with open(fname, 'r') as f: obj = json.load(f, object_hook=CSData.dict_to_obj)

        return obj

    def write(self):
        """ Output this structure to JSON """
        with open(self.path, 'w') as outp:
            json.dump(self, outp, default=CSData.convert_to_dict, sort_keys=True, indent=2, separators=(',', ': '))

    def __str__(self):
        return json.dumps(self, sort_keys=True, default=CSData.convert_to_dict, indent=2, separators=(',', ': '))

    @staticmethod
    def convert_to_dict(obj):
        """
        A function takes in a custom object and returns a dictionary representation of the object.
        This dict representation includes meta data such as the object's module and class names.
        """

        #  Populate the dictionary with object meta data
        obj_dict = {
            "__class__": obj.__class__.__name__,
            "__module__": obj.__module__
        }

        #  Populate the dictionary with object properties
        obj_dict.update(obj.__dict__)

        return obj_dict

    @staticmethod
    def dict_to_obj(our_dict):
        """
        Function that takes in a dict and returns a custom object associated with the dict.
        This function makes use of the "__module__" and "__class__" metadata in the dictionary
        to know which object type to create.
        """
        if "__class__" in our_dict:
            # Pop ensures we remove metadata from the dict to leave only the instance arguments
            class_name = our_dict.pop("__class__")

            # Get the module name from the dict and import it
            module_name = our_dict.pop("__module__")

            # We use the built in __import__ function since the module name is not yet known at runtime
            module = __import__(module_name)

            # Get the class from the module
            class_ = getattr(module, class_name)

            # Use dictionary unpacking to initialize the object
            obj = class_(**our_dict)
        else:
            obj = our_dict
        return obj

def cmd_build_cache(data, search_path, verbose=False, dryrun=False):
    """ Build a new cache file, maintaining the data that's already in it though if any exists """
    paths = find_all_color_dirs(search_path)

    def path_to_scheme(path):
        """ Convert the file name to a colour scheme name """
        path = path.strip()
        path = re.sub('\.vim$', '', os.path.basename(path))
        return path

    # Collect all the files in the paths
    for p in paths:
        for (dirpath, dirnames, filenames) in os.walk(p):
            for filename in filenames:
                # files.append(filename)list_of_files[filename] = os.sep.join([dirpath, filename])
                name = path_to_scheme(filename)
                rel_dir = dirpath.replace(search_path, '')
                rel_dir = re.sub(r'^(\\|/)?', '', rel_dir)
                if data.has(name=name):
                    idx = data.find(name=name)
                    if data.colourSchemes[idx].path != rel_dir:
                        data.colourSchemes[idx].path = rel_dir
                else:
                    data.colourSchemes.append(ColourScheme(
                        name=name,
                        path=rel_dir,
                    ))

    # Build cache
    for s in data.colourSchemes:
        if s.name not in data.cachedList:
            data.cachedList.append(s.name)

    for s in data.colourSchemes:
        if 'whitelist' in s.tags and s.name not in data.cachedWhitelist:
            data.cachedWhitelist.append(s.name)

    if s in data.cachedList:
        if not data.has(s):
            data.cachedList.remove(s)

    if s in data.cachedWhitelist:
        if not data.has(s):
            data.cachedWhitelist.remove(s)
        else:
            idx = data.find(s)
            if 'whitelist' not in data.colourSchemes[idx].tags:
                data.cachedWhitelist.remove(s)

def main():
    dotfiles_location = os.path.expanduser('~') + '/dotfiles'
    default_bundles_location = dotfiles_location + '/bundles/dein/repos';

    parser = argparse.ArgumentParser(
        description='Build a cache of available colours schemes, output them into a JSON file for vim plugins to read'
    )

    parser.add_argument('-n', '--dryrun',
        action='store_true',
        dest='dryrun',
        required=False,
        help='Dryrun mode (do not write to cache file)'
    )

    parser.add_argument('-v', '--verbose',
        action='store_true',
        dest='verbose',
        required=False,
        help='Increase verbosity'
    )

    parser.add_argument('-c', '--cache',
        action='store',
        dest='cache_file',
        required=False,
        metavar='CACHE_FILE',
        default=dotfiles_location + '/vim_colourscheme_cache.json',
        help='Cache file name'
    )

    parser.add_argument(
        action='store',
        dest='command', # maybe use an action to validate the commands with their args?
        nargs=1,
        help='Command to issue: generate, whitelist <name>, blacklist <name>, toggle-variant <name>'
    )

    parser.add_argument(
        dest='args',
        nargs='*'
    )

    try:
        args = parser.parse_args()
    except ValueError as e:
        print('Invalid options.', e, file=sys.stderr)
        sys.exit(1)

    # We never want to overwrite a cache (unless we do), so if the specified
    # cache file exists, always first load it and then pass it around
    if os.path.exists(args.cache_file):
        try:
            data = CSData.load(args.cache_file)
        except json.decoder.JSONDecodeError as e:
            print('Could not load cached file "%s"'%args.cache_file, e, file=sys.stderr)
            sys.exit(1)

    else:
        data = CSData(path=args.cache_file)

    def write_output(data):
        """ Little helper function to output if dryrun and verbose are right """
        if not args.dryrun:
             data.write()
        else:
            if args.verbose:
                print(data)

    if 'build_cache' == args.command[0]:
        cmd_build_cache(
            data=data,
            search_path=default_bundles_location,
            verbose=args.verbose, dryrun=args.dryrun
        )

        write_output(data)

    else:
        print('Unknown command "%s"'%(args.command), file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()

# vim:set expandtab sw=4 ts=4 sts=0 ffs=unix :
