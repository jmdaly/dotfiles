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

# Adjust the path
if [[ -e ${HOME}/.pathrc ]]; then
	source ${HOME}/.pathrc
fi

# Build Run PATH
# TODO See if I can replace this and the MANPATH with Environmental Modules.
#      They're finally being updated again.
local -a dirs;
export LINUXBREWHOME=${HOME}/.linuxbrew
dirs=(bin utils $(basename ${LINUXBREWHOME})/bin .composer/vendor/bin .rvm/bin .local/bin .fzf/bin .pyenv/bin);
for d in $dirs; do
	dir=${HOME}/${d};
	if [[ -e "${dir}" ]]; then
		export PATH=${dir}:${PATH}
	fi;
done

# If pyenv exists, initialise it
if [[ -e "${HOME}/.pyenv/bin" ]]; then
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# Build MAN path
dirs=($(basename ${LINUXBREWHOME})/man .rvm/man .local/man);
for d in $dirs; do
	dir=${HOME}/${d}/man;
	if [[ -e "${dir}" ]]; then
		export MANPATH=${dir}:${MANPATH}
	fi;
done

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
	# antigen bundle sorin-ionescu/prezto
	antigen bundle RobSis/zsh-reentry-hook
	antigen bundle jocelynmallon/zshmarks

	outp=$(which fzf)
	if [[ 0 == $?  ]]; then
		antigen bundle uvaes/fzf-marks
	fi

	# Plugin to check if a 256 colour terminal
	# is available, and enable all colours if
	# it is
	antigen bundle chrissicool/zsh-256color

	# Syntax highlighting bundle.
	antigen bundle zsh-users/zsh-syntax-highlighting

	# Load the theme.
	# The prezto theme uses a bunch of glyphs that don't show in putty.  If I'm
	# using putty, I'm probably connecting from Tinder(windows) to pof.. So
	# only use blinks on pof.  Or figure out how to detect putty.
	# Themes: robbyrussell, daveverwer candy clean pygalion, etc..
	if [[ "$(hostname)" == "tinder" || "$(hostname)" == "grinder" || "$(hostname)" == khea* ]]; then
		# Set some preferences for the bullet train theme:
		export BULLETTRAIN_CONTEXT_SHOW=true
		export BULLETTRAIN_TIME_SHOW=false
		export BULLETTRAIN_GIT_COLORIZE_DIRTY=true
		export BULLETTRAIN_RUBY_SHOW=false
		export BULLETTRAIN_GIT_BG="green"
		export BULLETTRAIN_DIR_FG="black"

		antigen theme caiogondim/bullet-train-oh-my-zsh-theme bullet-train
	else
		antigen theme blinks
	fi

	# Auto update
	antigen bundle unixorn/autoupdate-antigen.zshplugin

	# Tell antigen that you're done.
	antigen apply

fi

if [[ $(which urxvt 2>/dev/null) != "" ]]; then
	# Set the terminal to urxvt, for i3wm:
	export TERMINAL=urxvt
fi

# Use VIM wherever possible.  The latter fixes colours in non-gvim
export EDITOR=vim

# This doesn't seem to be applying when at the top
setopt no_share_history

# Autocompletion with an arrow-key driven interface
zstyle ':completion:*' menu select

# This option allows me to tab complete branch names with the oh-my-zsh git aliases.
# http://zsh.sourceforge.net/Doc/Release/Options.html#index-COMPLETEALIASES
setopt nocomplete_aliases

# Ignore untracked files for showing status on prompt
export DISABLE_UNTRACKED_FILES_DIRTY=true

# Get number pad return/enter key to work
#bindkey "${terminfo[kent]}" accept-line

# Alises
if [ -e ${HOME}/.bash_aliases ]; then
	source ${HOME}/.bash_aliases
fi

# Dir colours, used by solarized
if [ -x /usr/bin/dircolors ]; then
	test -r ${HOME}/.dircolors && eval "$(dircolors -b ${HOME}/.dircolors)" || eval "$(dircolors -b)"
fi

if [[ -e "${LINUXBREWHOME}" ]]; then
	# Linux Brew specific settings (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-linuxbrew-on-a-linux-vps)
	# See: https://github.com/Homebrew/linuxbrew/issues/47
	export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:/usr/lib64/pkgconfig:/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig:$PKG_CONFIG_PATH
	# Setup linux brew
	export PKG_CONFIG_PATH=${LINUXBREWHOME}/lib64/pkgconfig:${LINUXBREWHOME}/lib/pkgconfig:$PKG_CONFIG_PATH
	export MANPATH=${LINUXBREWHOME}/share/man:$MANPATH
	export INFOPATH=${LINUXBREWHOME}/share/info:$INFOPATH
fi

declare modules_enabled=0
declare -f module > /dev/null;
if [[ $? == 1 ]]; then
	modules_enabled=1;

	# Environmental Modules
	case "$0" in
	-sh|sh|*/sh)        modules_shell=sh   ;;
	-ksh|ksh|*/ksh)     modules_shell=ksh  ;;
	-zsh|zsh|*/zsh)     modules_shell=zsh  ;;
	-bash|bash|*/bash)  modules_shell=bash ;;
	esac

	export MODULEPATH=/usr/share/modules/modulefiles

	# #module() { eval `/usr/Modules/$MODULE_VERSION/bin/modulecmd $modules_shell $*`; }
	modulecmd=/usr/bin/modulecmd
	module() { eval `${modulecmd} $modules_shell $*`; }

	#module use ${HOST}/.modulefiles
fi;

if [[ $(hostname) == "khea" ]]; then
	module use /usr/local/Modules/default/modulefiles
	# module use /opt/pgi/modulefiles
	module load modules
	module load khea

	#module load mayofest
	#module load diplomacy
	module load bona
	#module load youtuber

	export CONAN_SYSREQUIRES_MODE=disabled CONAN_SYSREQUIRES_SUDO=0

	# CMC
	# export PATH=~newarmn/tools/run-tools/linux24-x86-64/bin:$PATH

elif [[ $(hostname) = dena* ]]; then
	# This should be a system "module use"!
	module use /cm/shared/denaModules

	if [[ $(hostname) = dena[5-6] ]]; then
		module use /software/arch/intel64/modules/all
	else
		module use /software/arch/amd64/modules/all
	fi

	# PGI
	module use /cm/shared/apps/pgi/modulefiles

	# defaults
	module load shared modules

	# Development
	module load pgi64/2013 slurm

	if [[ $(hostname) == "dena" ]]; then
		# Admin modules
		module load cmsh cmgui
	fi
fi

# Actvate the SSH-Agent.  Following instructions at
# http://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add/ to
# avoid an agent per shell.
# Troubleshooting https://developer.github.com/v3/guides/using-ssh-agent-forwarding/
if [[ -e "${HOME}/dotfiles/ssh-find-agent/ssh-find-agent.sh" ]]; then
	. "${HOME}/dotfiles/ssh-find-agent/ssh-find-agent.sh"

	# Automatically choose the first agent
	ssh-find-agent -a
	if [ -z "$SSH_AUTH_SOCK" ]
	then
	   eval $(ssh-agent) > /dev/null
	   ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
	fi
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vim: sw=4 sts=0 ts=4 noet ffs=unix :
