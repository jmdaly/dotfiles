#!/bin/zsh

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
	declare base=$(dirname $(realpath $0))
#	exit 1;
else
	declare base=${h}/dotfiles
fi;


# First ensure that the submodules in this repo
# are available and up to date:
cd ${base}
git submodule init
git submodule update
cd ${h}


files=(.zshrc .bashrc .bash_aliases .bash_profile .profile .login .logout .vimrc .gvimrc .tmux.conf .screenrc .pathrc .modulefiles .vncrc .gdbinit .screenrc)
# .config/autokey

declare backup_dir=${h}/.dotfiles_backup

# Create a backup directory:
mkdir -p ${h}/.dotfiles_backup

for f in $files; do
	if [[ $f =~ ".*" ]]; then
		src=${f/.//}
	else
		src=$f
	fi;
	if [[ ! -h ${h}/$f ]]; then
		if [[ -e ${h}/$f && -e ${base}/${src} ]]; then
			echo "Backing up $f"
			mv ${h}/$f ${backup_dir}/$f
		fi
		if [[ -e ${base}/${src} ]]; then
			#echo "Installing $f"
			if [[ "$copy" == 1 ]]; then
				# On cygwin, symlinks when used through gvim
				# can be an issue
				cp ${base}/${src} $f;
			else
				ln -s ${base}/${src} $f
			fi;
		fi
	else
		echo "Skipping synlink $f"
	fi
done;

cd ${h} && source .zshrc
