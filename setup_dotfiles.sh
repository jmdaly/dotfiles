#!/bin/zsh

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

declare base=${HOME}/dotfiles

# Check for required dependencies before continuing:
if [[ ! -a $(which git) ]]; then
  echo "Error: git is not installed. Please install git first."
  exit 1
fi

if [[ ! -a $(which curl) ]]; then
  echo "Error: curl is not installed. Please install curl first."
  exit 1
fi

if [[ ! -a $(which stow) ]]; then
  echo "Error: stow is not installed. Please install stow first."
  exit 1
fi

if [[ ! -a $(which unzip) ]]; then
  echo "Error: unzip is not installed. Please install unzip first."
  exit 1
fi

# Set up tmux plugin manager:
mkdir -p ~/.tmux/plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Set up antigen, the zsh plugin manager:
mkdir -p ~/git
if [ ! -d ~/git/antigen ]; then
	git clone https://github.com/zsh-users/antigen ~/git/antigen
fi

# Get vim-plug, the plugin manager I use
# for vim:
if [ ! -f ~/.vim/autoload/plug.vim ]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -f ~/.config/nvim/autoload/plug.vim ]; then
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Get the Base16 colour schemes
mkdir -p ~/.config
if [ ! -d ~/.config/base16-shell ]; then
	git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
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

# Get the Meslo font, used by the terminal:
if [ ! -f ~/.fonts/Meslo\ LG\ S\ Regular\ for\ Powerline.otf ]; then
	curl -fLo ~/.fonts/Meslo\ LG\ S\ Regular\ for\ Powerline.otf https://github.com/powerline/fonts/raw/master/Meslo/Meslo%20LG%20S%20Regular%20for%20Powerline.otf
	fc-cache -vf ~/.fonts/
fi

# Get the Hack font, another good terminal/code font:
if [ ! -f ~/.fonts/Hack-Regular.ttf ]; then
	curl -fLo /tmp/hack/hack.zip --create-dirs https://github.com/chrissimpkins/Hack/releases/download/v2.020/Hack-v2_020-ttf.zip
	cd /tmp/hack && unzip hack.zip
	cp *.ttf ~/.fonts
	fc-cache -vf ~/.fonts/
fi

# Wallpapers for the window manager:
if [ ! -f ~/.config/wallpapers/wall.png ]; then
	curl -fLo ~/.config/wallpapers/wall.png --create-dirs http://jmdaly.ca/media/wall.png
fi

# Set up all of the configs:
cd ${base}/stow

# This for loop iterates through all directories
# contained in the stow directory. This makes
# it easy to add configurations for new applications
# without having to modify this script.
for app in */; do
	stow -t ${HOME} $app
done;
