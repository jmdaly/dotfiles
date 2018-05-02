# Update the dotfiles repo to make sure we have all changes:
~/dotfiles/doupdate.sh

source ~/git/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found
antigen bundle vi-mode

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme caiogondim/bullet-train-oh-my-zsh-theme bullet-train

# Tell antigen that you're done.
antigen apply

export EDITOR=nvim

# Set the terminal to st, for i3wm:
export TERMINAL=st

# Set ccache to use distcc if distcc is available:
if type distcc > /dev/null; then
  export CCACHE_PREFIX="distcc"
fi

# Set fzf to use ag if ag is available:
if type ag > /dev/null; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
fi

# Ensure Google Test tests always show colour output:
export GTEST_COLOR=yes

# Set some preferences for the bullet train theme:
export BULLETTRAIN_CONTEXT_SHOW=true
export BULLETTRAIN_TIME_SHOW=false
export BULLETTRAIN_GIT_COLORIZE_DIRTY=true
export BULLETTRAIN_RUBY_SHOW=false
export BULLETTRAIN_GIT_BG="green"
export BULLETTRAIN_DIR_FG="black"
export BULLETTRAIN_PROMPT_CHAR="$ "

BULLETTRAIN_PROMPT_ORDER=(
  status 
  custom 
  context 
  dir 
  perl 
  ruby 
  virtualenv 
  go 
  git 
  hg 
  cmd_exec_time
)

# Set up ninja tab completion:
source ~/dotfiles/ninja/_ninja

# Aliases
alias nv='nvim'

# When switching to normal mode for vi key bindings,
# make the timeout small:
export KEYTIMEOUT=1

# Script to adjust colour palette in the terminal for gruvbox:
GRUVBOX_PALETTE="$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"
[[ -s $GRUVBOX_PALETTE ]] && source $GRUVBOX_PALETTE

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Check if there's a local zsh file to source, and source it
# if it exists:
[ -f ~/.localzshrc ] && source ~/.localzshrc

# fbr - checkout git branch (including remote branches)
b() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
