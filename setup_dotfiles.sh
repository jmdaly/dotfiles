#!/bin/bash

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

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

cd && source .zshrc
