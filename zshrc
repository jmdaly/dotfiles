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

# z - awesome directory switching plugin
antigen bundle rupa/z

# fzf-marks - a plugin to allow bookmarking
# directories, and then fuzzy searching through
# the bookmarks using fzf
antigen bundle uvaes/fzf-marks

# Load the theme.
antigen theme caiogondim/bullet-train-oh-my-zsh-theme bullet-train

# Tell antigen that you're done.
antigen apply

export EDITOR=vim

# Set the terminal to urxvt, for i3wm:
export TERMINAL=urxvt

# Set ccache to use distcc:
export CCACHE_PREFIX="distcc"

# Ensure Google Test tests always show colour output:
export GTEST_COLOR=yes

# Set some preferences for the bullet train theme:
export BULLETTRAIN_CONTEXT_SHOW=true
export BULLETTRAIN_TIME_SHOW=false
export BULLETTRAIN_GIT_COLORIZE_DIRTY=true
export BULLETTRAIN_RUBY_SHOW=false
export BULLETTRAIN_GIT_BG="green"
export BULLETTRAIN_DIR_FG="black"

# Set up ninja tab completion:
source ~/dotfiles/ninja/_ninja

# Adjust the path
source ~/.pathrc

# Aliases
alias nv='nvim'

# Enable true colour in neovim if we're using a true
# colour terminal:
if [ "$TERM" = "st-256color" ]; then
	export NVIM_TUI_ENABLE_TRUE_COLOR=1
fi

# Script to adjust colour palette in the terminal for gruvbox:
GRUVBOX_PALETTE="$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"
[[ -s $GRUVBOX_PALETTE ]] && source $GRUVBOX_PALETTE

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Check if there's a local zsh file to source, and source it
# if it exists:
[ -f ~/.localzshrc ] && source ~/.localzshrc
