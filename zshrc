# Update the dotfiles repo to make sure we have all changes:
~/dotfiles/doupdate.sh

source ~/dotfiles/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme blinks

# Tell antigen that you're done.
antigen apply

export EDITOR=vim

export TERM="xterm-256color"

# Adjust the path
source ~/.pathrc

