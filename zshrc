if [[ -e ${HOME}/dotfiles/doupdate.sh ]]; then
	# Update the dotfiles repo to make sure we have all changes:
	${HOME}/dotfiles/doupdate.sh
fi

# Uncomment if I want history shared across all terminals
# setopt histignorealldups sharehistory
setopt no_share_history
#unsetopt share_history

# Keep 1000 lines of history within the shell and save it to ${HOME}/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=${HOME}/.zsh_history

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"


if [[ -e ${HOME}/dotfiles/antigen/antigen.zsh ]]; then
	source ${HOME}/dotfiles/antigen/antigen.zsh

	# Load the oh-my-zsh's library.
	antigen use oh-my-zsh

	# Bundles from the default repo (robbyrussell's oh-my-zsh).
	# These all take about a second to load
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

	# Auto update
	antigen bundle unixorn/autoupdate-antigen.zshplugin

	# Tell antigen that you're done.
	antigen apply


elif [[ -e ${HOME}/.oh-my-zsh ]]; then
	# Used with babun in cygwin.  Should attempt to merge with Antigen
	# one day

	# Path to your oh-my-zsh installation.
	export ZSH=${HOME}/.oh-my-zsh
	
	# Set name of the theme to load.
	# Look in ~/.oh-my-zsh/themes/
	# Optionally, if you set this to "random", it'll load a random theme each
	# time that oh-my-zsh is loaded.
	ZSH_THEME="babun"

	# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
	# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
	# Example format: plugins=(rails git textmate ruby lighthouse)
	# Add wisely, as too many plugins slow down shell startup.
	plugins=(git)

	export PATH=$HOME/bin:/usr/local/bin:$PATH
	
	source $ZSH/oh-my-zsh.sh

fi
	
# Use VIM wherever possible.  The latter fixes colours in non-gvim
export EDITOR=vim
export TERM=xterm-256color

# This doesn't seem to be applying when at the top
setopt no_share_history

# Autocompletion with an arrow-key driven interface
zstyle ':completion:*' menu select

# Autocompletion of command line switches for aliases
setopt completealiases

# Ignore untracked files for showing status on prompt
export DISABLE_UNTRACKED_FILES_DIRTY=true

# Get number pad return/enter key to work
#bindkey "${terminfo[kent]}" accept-line

# ###########################################################
# # Define some keys ( http://zshwiki.org/home/zle/bindkeys )
# #
# # Not sure if these are still needed.  I had only implemented
# # them on dena
# # #
# typeset -A key
# key[Home]=${terminfo[khome]}
# key[End]=${terminfo[kend]}
# key[Insert]=${terminfo[kich1]}
# key[Delete]=${terminfo[kdch1]}
# key[Up]=${terminfo[kcuu1]}
# key[Down]=${terminfo[kcud1]}
# key[Left]=${terminfo[kcub1]}
# key[Right]=${terminfo[kcuf1]}
# key[PageUp]=${terminfo[kpp]}
# key[PageDown]=${terminfo[knp]}
#
# # Setting up more key bindings
# bindkey '' beginning-of-line
# bindkey '' end-of-line
# bindkey '' history-incremental-search-backward
# bindkey "${key[Delete]}" delete-char
# ###########################################################

# Alises
if [ -e ${HOME}/.bash_aliases ]; then
	source ${HOME}/.bash_aliases
fi

# Dir colours, used by solarized
if [ -x /usr/bin/dircolors ]; then
	test -r ${HOME}/.dircolors && eval "$(dircolors -b ${HOME}/.dircolors)" || eval "$(dircolors -b)"
fi


# Adjust the path
if [[ -e ${HOME}/.pathrc ]]; then
	source ${HOME}/.pathrc
fi

local -a dirs;
dirs=(bin utils .linuxbrew/bin .composer/vendor/bin .rvm/bin .local/bin clang+llvm-3.6.1-x86_64-linux-gnu/bin AppData/Roaming/Python/Scripts);
for d in $dirs; do
	dir=${HOME}/${d};
	if [[ -e $dir ]]; then
		export PATH=${dir}:${PATH}
	fi;
done

declare modules_enabled=0
declare -f module > /dev/null;
if [[ $? == 1 ]]; then
	modules_enabled=1;

	# Environmental Modules
	case "$0" in
	-sh|sh|*/sh)	modules_shell=sh ;;
	-ksh|ksh|*/ksh)	modules_shell=ksh ;;
	-zsh|zsh|*/zsh)	modules_shell=zsh ;;
	-bash|bash|*/bash)	modules_shell=bash ;;
	esac

	export MODULEPATH=/usr/share/modules/modulefiles

	#module() { eval `/usr/Modules/$MODULE_VERSION/bin/modulecmd $modules_shell $*`; }
	if [[ $(hostname) == "pontus.cee.carleton.ca" ]]; then
		modulecmd=/usr/local/Modules/3.2.9/bin/modulecmd
	else
		modulecmd=/usr/bin/modulecmd
	fi
	module() { eval `${modulecmd} $modules_shell $*`; }

	#module use ${HOST}/.modulefiles
fi;


if [[ -e $(which fuck 2>/dev/null) ]]; then
	eval "$(thefuck --alias)"
fi

if [[ $(hostname) == "khea" ]]; then
	module use /usr/local/Modules/default/modulefiles/
	module load modules

	module load khea

	#module load mayofest
	#module load diplomacy
	module load bona
	#module load youtuber

	# CMC
	export PATH=~newarmn/tools/run-tools/linux24-x86-64/bin:$PATH
elif [[ $(hostname) == "pof" || $(hostname) == "tinder" ]]; then
	module use /usr/share/modules/modulefiles
	module load modules

	module load neptec 3dri

	# Set up ninja tab completion:
	if [[ -e /usr/share/zsh/functions/Completion/_ninja ]]; then
		source /usr/share/zsh/functions/Completion/_ninja
	fi;

elif [[ $(hostname) = dena* ]]; then
	# This should be a system "module use"!
	module use /cm/shared/denaModules

	if [[ $(hostname) = dena[5-6] ]]; then
		module use /software/arch/intel64/modules/all
	else
		module use /software/arch/amd64/modules/all
	fi

	# defaults
	module load shared modules

	# Development
	export PGI_DEFAULT=2013
	module load pgi slurm

	if [[ $(hostname) == "dena" ]]; then
		# Admin modules
		module load cmsh cmgui
	fi

elif [[ "$(hostname)" == "pontus.cee.carleton.ca" ]]; then
	module load pontus

elif [[ "$(uname -o)" == "Cygwin" ]]; then
	# This targets windows laptop at Neptec

	# Modules isn't available here, so duplicate the most common aliases
	if [[ "${modules_enabled}" == "0" ]]; then
		base=${HOME}/workspace/opal2
		ARCH=o2win64
		export bld=${base}/build-3dri-${ARCH}-release
		ws=${base}/3dri/Applications/OPAL2/3DRiWebScheduler
		export wss=${ws}/src
		export wsi=${ws}/include/3DRiWebScheduler
	fi
fi;

# vim: sw=4 sts=0 ts=4 noet ffs=unix :
