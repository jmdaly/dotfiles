# Update the dotfiles repo to make sure we have all changes:
~/dotfiles/doupdate.sh

# Uncomment if I want history shared across all terminals
# setopt histignorealldups sharehistory
setopt no_share_history
#unsetopt share_history

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)



source ~/dotfiles/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
# Themes: robbyrussell, daveverwer candy clean pygalion, etc..
antigen theme blinks

# Tell antigen that you're done.
antigen apply

export EDITOR=vim

# Get number pad return/enter key to work
#bindkey "${terminfo[kent]}" accept-line

# Adjust the path
source ~/.pathrc

# Alises
if [ -e ~/.bash_aliases ]; then
	#echo "Sourcing bash_aliases"
	source ~/.bash_aliases
fi

# Environmental Modules
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
if [[ $(hostname) == "khea" ]]; then
	module use /usr/share/modules/versions
	module use /usr/local/Modules/default/modulefiles/
	module load modules

	#module load mayofest 
	module load bona
	module load youtuber
	#module load gys

	# Adjust the path
	export PATH="${HOME}/utils:$PATH"

	# Ruby I think?
	export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
elif [[ $(hostname) == "pof" || $(hostname) == "tinder" ]]; then
	module use /usr/share/modules/modulefiles
	module load modules

	module load 3dri
fi;
