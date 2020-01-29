# Attempting to use gpg-agent over ssh-agent.  Do this before doupdate or else
# it'll prompt for the SSH passphrase rather than the keyring passphrase
# https://eklitzke.org/using-gpg-agent-effectively
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export GPG_TTY=$(tty)

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

# On the WSL, it's handy to use Windows $env:temp space
WSL_TEMP_GUESS=${HOME}/tmp
if [[ -O ${WSL_TEMP_GUESS} && -d ${WSL_TEMP_GUESS} ]]; then
	TMPDIR=${WSL_TEMP_GUESS}
fi

# Adjust the path
if [[ -e ${HOME}/.pathrc ]]; then
	source ${HOME}/.pathrc
fi

if [[ -e ${HOME}/.zplug ]]; then
	source ${HOME}/.zplug/init.zsh

	# Bundles from robbyrussell's oh-my-zsh.
	zplug "plugins/git", from:oh-my-zsh
	zplug "plugins/command-not-found", from:oh-my-zsh
	zplug "lib/directories", from:oh-my-zsh          # Provides the directory stack

	zplug "lib/history", from:oh-my-zsh              # Provides history management
	zplug "lib/completion", from:oh-my-zsh           # Provides completion of dot directories

	if [[ -e /home/linuxbrew/.linuxbrew/share/zsh/site-functions ]]; then
		fpath+=('/home/linuxbrew/.linuxbrew/share/zsh/site-functions')
	fi

	if [[ "CST-PC90" == "$(hostname)" ]]; then
		# Pure Prompt https://github.com/sindresorhus/pure
		fpath+=('/usr/local/lib/node_modules/pure-prompt/functions')

		ZSH_THEME=""
		zplug "mafredri/zsh-async", from:github
		zplug "sindresorhus/pure," use:pure.zsh, from:github, as:theme
	else
		zplug "plugins/vi-mode", from:oh-my-zsh

		zplug "lib/theme-and-appearance", from:oh-my-zsh # Provides auto cd, and some other appearance things

		# Syntax highlighting bundle.
		zplug "zsh-users/zsh-syntax-highlighting"

		# Load the theme.
		zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme
		# zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
	fi

	# Bookmarks in fzf
	outp=$(which fzf)
	zplug "uvaes/fzf-marks"

	# Install plugins if there are plugins that have not been installed
	if ! zplug check --verbose; then
		printf "Install? [y/N]: "
		if read -q; then
			echo; zplug install
		fi
	fi

	# Then, source plugins and add commands to $PATH
	zplug load
fi

if [[ $(which urxvt 2>/dev/null) != "" ]]; then
	# Set the terminal to urxvt, for i3wm:
	export TERMINAL=urxvt
fi

# Use VIM wherever possible.  The latter fixes colours in non-gvim
if [[ $(which nvim 2>/dev/null) != "" ]]; then
	export EDITOR=nvim
else
	export EDITOR=vim
fi

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

# github.com/goreliu/wsl-terminal recommended adding this
[[ -z "$TMUX" && -n "$USE_TMUX" ]] && {
	[[ -n "$ATTACH_ONLY" ]] && {
		tmux a 2>/dev/null || {
			cd && exec tmux
		}
		exit
	}

	tmux new-window -c "$PWD" 2>/dev/null && exec tmux a
	exec tmux
}

# Alises
if [ -e ${HOME}/.bash_aliases ]; then
	source ${HOME}/.bash_aliases
fi

# Dir colours, used by solarized
if [ -x /usr/bin/dircolors ]; then
	test -r ${HOME}/.dircolors && eval "$(dircolors -b ${HOME}/.dircolors)" || eval "$(dircolors -b)"
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
	module load modules
	module load khea
	module load solacom

	module load bona

	export CONAN_SYSREQUIRES_MODE=disabled CONAN_SYSREQUIRES_SUDO=0

elif [[ $(hostname) = CST-PC* ]]; then
	WIN_HOME=/mnt/c/users/matthew.russell

	# Use Window's Docker https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly
	export DOCKER_HOST=tcp://localhost:2375
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

# Load default python virtual env.
declare python_venv="${HOME}/.virtualenvs/default"
if [[ -e "${python_venv}/bin" ]]; then
	source "${python_venv}/bin/activate"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vim: sw=4 sts=0 ts=4 noet ffs=unix :
