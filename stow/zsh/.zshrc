# Update the dotfiles repo to make sure we have all changes:
~/dotfiles/doupdate.sh

# Check if z-plug is installed or not. If not, install it:

if [[ ! -d ~/.zplug ]]; then
  echo "z-plug not installed. Installing it."
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source ~/.zplug/init.zsh

# Bundles from robbyrussell's oh-my-zsh.
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "lib/completion", from:oh-my-zsh # Better tab completion
zplug "lib/directories", from:oh-my-zsh # Provides the directory stack
zplug "lib/history", from:oh-my-zsh # Provides history management
zplug "lib/completion", from:oh-my-zsh # Provides completion of dot directories
zplug "lib/theme-and-appearance", from:oh-my-zsh # Provides auto cd, and some other appearance things

# Syntax highlighting bundle.
zplug "zsh-users/zsh-syntax-highlighting"

# Load the theme.
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Disable docker and node versions in prompt. This sends
# unexpected characters that lead to my shell
# getting closed.
export SPACESHIP_DOCKER_SHOW=false
export SPACESHIP_NODE_SHOW=false
export SPACESHIP_PACKAGE_SHOW=false

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
