#!/bin/bash

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

if [[ "$1" == "" ]]; then
	h=${HOME}
else
	h=$1
fi;

if [[ "$2" == "" ]]; then
	copy=0
else
	copy=1
fi;


if [[ "$(which realpath)" == "" ]]; then
	echo "Cannot find realpath.  Use apt-get to install it"
	declare base=${h}/dotfiles
	#exit 1;
else
	declare base=$(dirname $(realpath $0))
	declare base=${h}/dotfiles
fi;

# First ensure that the submodules in this repo
# are available and up to date:
if [[ "$(uname -o)" != "Cygwin" ]]; then
	cd ${base}
	git submodule init
	git submodule update
fi
cd ${h}

#
# Declare the files that we always want to copy over.
declare -a files;
files=(.bash_aliases)
if [[ "${TRUE_HOST}" != "" ]]; then
	# We're on env can machines
	files+=(.pathrc .vncrc .gdbinit)
elif [[ "$(uname -o)" == "Cygwin" ]]; then
	# Do nothing
else
	files+=(.zshrc .bashrc .bash_profile .profile .login .logout .modulefiles .vncrc .gdbinit .dircolors)
fi

# Check if our environment supports these
if [[ "$(which vim)" != "" ]]; then
	files+=('.vimrc')
fi
if [[ "$(which tmux)" != "" ]]; then
	files+=('.tmux.conf')
	if [[ ! -e ${h}/.tmux ]]; then
		git clone https://github.com/tmux-plugins/tpm ${h}/.tmux/plugins/tpm
	fi
fi
if [[ "$(which screen)" != "" ]]; then
	files+=('.screenrc')
fi
if [[ "$(which sqlite3)" != "" ]]; then
	files+=('.sqliterc')
fi
if [[ "$(which ctags)" != "" ]]; then
	files+=('.ctags')
fi

# .config/autokey

declare backup_dir=${h}/.dotfiles_backup

# Create a backup directory:
mkdir -p ${h}/.dotfiles_backup

for f in ${files[@]}; do
	# Local file in dotfile fir
	if [[ $f =~ .* ]]; then
		src=${f/.//}
	else
		src=$f
	fi;
	if [[ ! -h ${h}/$f ]]; then
		if [[ -e ${h}/$f && -e ${base}/${src} && ! -h ${h}/${f} ]]; then
			echo "Backing up $f"
			mv ${h}/$f ${backup_dir}/$f
		fi
		if [[ -e ${base}/${src} ]]; then
			#echo "Installing $f"
			if [[ "$copy" == 1 ]]; then
				# On cygwin, symlinks when used through gvim
				# can be an issue
				cp -r ${base}/${src} $f;
			else
				ln -s ${base}/${src} $f
			fi;
		fi
	else
		echo "Skipping symlink $f"
	fi
done;

cd $h
if [[ -e .vimrc ]]; then
	ln -s .vimrc .nvimrc
fi
if [[ -e .modulefiles ]]; then
	ln -s .modulefiles/.modulerc ./
fi

# Can no longer to this as I'm typically using zsh
# and this is writting in bash.  I have to keep it
# in bash in order to have it on CMC machines
#cd ${h} && source .zshrc

# vim: ts=3 sw=3 sts=0 noet :
