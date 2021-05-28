# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Update the dotfiles repo to make sure we have all changes:
~/dotfiles/doupdate.sh

# Check if z-plug is installed or not. If not, install it:

if [[ ! -d ~/.zplug ]]; then
  echo "z-plug not installed. Installing it."
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

echo "Sourcing zplug"
source ~/.zplug/init.zsh

echo "Specifying packages"
# Bundles from robbyrussell's oh-my-zsh.
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/gitfast", from:oh-my-zsh # Faster git command line completion
zplug "plugins/wd", from:oh-my-zsh # Warp directory - easily switch to particular directories
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "lib/completion", from:oh-my-zsh # Better tab completion
zplug "lib/directories", from:oh-my-zsh # Provides the directory stack
zplug "lib/history", from:oh-my-zsh # Provides history management
zplug "lib/completion", from:oh-my-zsh # Provides completion of dot directories
zplug "lib/theme-and-appearance", from:oh-my-zsh # Provides auto cd, and some other appearance things

# Syntax highlighting bundle.
# zplug "zsh-users/zsh-syntax-highlighting"

# Load the theme.
zplug romkatv/powerlevel10k, as:theme, depth:1

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Installing new zsh plugins..."
    echo; zplug install
fi

echo "Loading zplug"
# Then, source plugins and add commands to $PATH
zplug load

# Increase history file sizes, so we can store all history
export HISTSIZE=1000000000
export SAVEHIST=1000000000

# Disable docker and node versions in prompt. This sends
# unexpected characters that lead to my shell
# getting closed.
export SPACESHIP_DOCKER_SHOW=false
export SPACESHIP_NODE_SHOW=false
export SPACESHIP_PACKAGE_SHOW=false

export EDITOR=nvim

# Set the terminal to st, for i3wm:
export TERMINAL=st

# Set ccache to use icecc if icecc is available:
if type icecc > /dev/null; then
  export CCACHE_PREFIX="icecc"
fi

# If bat is available, set the theme
if type bat > /dev/null; then
  export BAT_THEME="Material-Theme"
  export COLORTERM=24bit
  alias cat='bat'
fi

# Set fzf to use ag if ag is available:
if type ag > /dev/null; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
fi
# Nord colour scheme for fzf
export FZF_DEFAULT_OPTS='--color dark'

# If lsd is available, use it in place of ls
if type lsd > /dev/null; then
  alias ls='lsd'
fi

# Ensure Google Test tests always show colour output:
export GTEST_COLOR=yes

# Set up ninja tab completion:
source ~/dotfiles/ninja/_ninja

# Aliases
alias nv='nvim'

# When switching to normal mode for vi key bindings,
# make the timeout small:
export KEYTIMEOUT=1

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

# Create and switch to a directory in one command
function mdcd {
    command mkdir $1 && cd $1
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
