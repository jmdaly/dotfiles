# Update the dotfiles repo to make sure we have all changes:
GIT_DIR=~/dotfiles/.git GIT_WORK_TREE=~/dotfiles git pull

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

# Adjust the path
source ~/.pathrc

# Alises
source ~/.bash_aliases

# Modules
case "$0" in
          -sh|sh|*/sh)	modules_shell=sh ;;
       -ksh|ksh|*/ksh)	modules_shell=ksh ;;
       -zsh|zsh|*/zsh)	modules_shell=zsh ;;
    -bash|bash|*/bash)	modules_shell=bash ;;
esac
export MODULEPATH=/home/matt/.modulefiles
# System
#export MODULEPATH=/usr/share/modules/modulefiles

#module() { eval `/usr/Modules/$MODULE_VERSION/bin/modulecmd $modules_shell $*`; }
module() { eval `/usr/bin/modulecmd $modules_shell $*`; }

