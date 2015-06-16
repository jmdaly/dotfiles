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

# Plugin to check if a 256 colour terminal
# is available, and enable all colours if
# it is
antigen bundle chrissicool/zsh-256color

# Load the theme.
antigen theme blinks

# Tell antigen that you're done.
antigen apply

export EDITOR=vim

# Set up ninja tab completion:
source ~/dotfiles/ninja/_ninja

# Adjust the path
source ~/.pathrc

