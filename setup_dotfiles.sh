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

files=(.zshrc .vimrc .tmux.conf .gitconfig .pathrc .ctags)

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
			echo "Installing $f"
			ln -s ${base}${src} $f
		fi
	else
		echo "Skipping synlink $f"
	fi
done;

# Set up symlinks for tmux plugins:
mkdir -p ~/.tmux/plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
	ln -s ~/dotfiles/tpm ~/.tmux/plugins/tpm
fi

# Get vim-plug, the plugin manager I use
# for vim:
if [ ! -f ~/.vim/autoload/plug.vim ]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -f ~/.config/nvim/autoload/plug.vim ]; then
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Set up symlinks for files that don't go
# in the home directory:
mkdir -p ~/.config/i3
if [ ! -f ~/.config/i3/config ]; then
	ln -s ~/dotfiles/i3 ~/.config/i3/config
fi

mkdir -p ~/.config/i3blocks
if [ ! -f ~/.config/i3blocks/config ]; then
	ln -s ~/dotfiles/i3blocks.conf ~/.config/i3blocks/config
fi

mkdir -p ~/.config/nvim
if [ ! -f ~/.config/nvim/init.vim ]; then
	ln -s ~/dotfiles/vimrc ~/.config/nvim/init.vim
fi

# Set up fonts

# Download fonts if we need them:
if [ ! -f ~/.fonts/fontawesome-webfont.ttf ]; then
	curl -fLo ~/.fonts/fontawesome-webfont.ttf --create-dirs https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf
fi

# Get the Yosemite system font
if [ ! -f ~/.fonts/System\ San\ Francisco\ Display\ Regular.ttf ]; then
	curl -fLo /tmp/sanfrancisco.zip https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
	cd /tmp && unzip sanfrancisco.zip
	cp /tmp/YosemiteSanFranciscoFont-master/*.ttf ~/.fonts
fi

