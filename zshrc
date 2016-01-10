# Update the dotfiles repo to make sure we have all changes:
~/dotfiles/doupdate.sh

source ~/dotfiles/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found
# turn on vi mode
antigen bundle vi-mode

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Plugin to check if a 256 colour terminal
# is available, and enable all colours if
# it is
antigen bundle chrissicool/zsh-256color

# z - awesome directory switching plugin
antigen bundle rupa/z

# fzf-marks - a plugin to allow bookmarking
# directories, and then fuzzy searching through
# the bookmarks using fzf
antigen bundle uvaes/fzf-marks

# Load the theme.
antigen theme blinks

# Tell antigen that you're done.
antigen apply

export EDITOR=vim

# Set the terminal to urxvt, for i3wm:
export TERMINAL=urxvt

# Set ccache to use distcc:
export CCACHE_PREFIX="distcc"

# Ensure Google Test tests always show colour output:
export GTEST_COLOR=yes

# Set up ninja tab completion:
source ~/dotfiles/ninja/_ninja

# Adjust the path
source ~/.pathrc

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
