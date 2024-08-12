#!/usr/bin/env bash

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

base=${HOME}/dotfiles

# Check for required dependencies before continuing:
if ! command -v git &> /dev/null; then
  echo "Error: git is not installed. Please install git first."
  exit 1
fi

if ! command -v stow &> /dev/null; then
  echo "Error: stow is not installed. Please install stow first."
  exit 1
fi

# Set up tmux plugin manager:
mkdir -p ~/.tmux/plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Set up all of the configs:
cd ${base}/stow

# This for loop iterates through all directories
# contained in the stow directory. This makes
# it easy to add configurations for new applications
# without having to modify this script.
for app in */; do
  stow -t ${HOME} $app
done

# If we have bat, update the theme cache in case new themes
# have been added
if command -v bat &> /dev/null; then
  echo "Updating bat cache"
  bat cache --build
fi
