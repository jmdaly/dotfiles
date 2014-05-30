#!/bin/zsh

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

# First ensure that the submodules in this repo
# are available and up to date:
cd ~/git/dotfiles
git submodule init
git submodule update
cd -

# Create a backup directory:
mkdir -p ~/.dotfiles_backup

mv ~/.zshrc ~/.dotfiles_backup
ln -s ~/git/dotfiles/zshrc ~/.zshrc

mv ~/.vimrc ~/.dotfiles_backup
ln -s ~/git/dotfiles/vimrc ~/.vimrc

mv ~/.gitconfig ~/.dotfiles_backup
ln -s ~/git/dotfiles/gitconfig ~/.gitconfig

mv ~/.tmux.conf ~/.dotfiles_backup
ln -s ~/git/dotfiles/tmux.conf ~/.tmux.conf

mv ~/.pathrc ~/.dotfiles_backup
# Since paths are site-specific, we just copy the
# default one instead of symlinking it:
cp ~/git/dotfiles/pathrc ~/.pathrc

cd && source .zshrc
