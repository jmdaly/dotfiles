#!/bin/zsh

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

if [[ "$(which realpath)" == "" ]]; then
	echo "Cannot find realpath.  Use apt-get to install it"
	declare base=$(dirname $(realpath $0))
#	exit 1;
else
	#declare base=/home/$(whoami)/dotfiles
	declare base=${HOME}/dotfiles
fi;

# First ensure that the submodules in this repo
# are available and up to date:
cd ${base}
git submodule init
git submodule update
cd ~

files=(.zshrc .vimrc .tmux.conf .gitconfig .pathrc)

declare backup_dir=~/.dotfiles_backup

# Create a backup directory:
mkdir -p ~/.dotfiles_backup

for f in $files; do
	if [[ $f =~ ".*" ]]; then
		src=${f/.//}
	else
		src=$f
	fi;
	if [[ ! -h ~/$f ]]; then
		if [[ -e ~/$f && -e ${base}/${src} ]]; then
			echo "Backing up $f"
			mv ~/$f ${backup_dir}/$f
		fi
		if [[ -e ${base}/${src} ]]; then
			#echo "Installing $f"
			ln -s ${base}/${src} $f
		fi
	else
		echo "Skipping synlink $f"
	fi
done;

cd && source .zshrc
