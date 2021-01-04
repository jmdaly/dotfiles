if [[ "undefined" == "${DOTFILES_DIT:-undefined}" ]]; then
	declare DOTFILES_DIR="${HOME}/dotfiles"
fi

source ${DOTFILES_DIR:-${HOME}/dotfiles}/rclib.sh

if [[ "$(_exists gpgconf)" != "1" ]]; then
	# Attempting to use gpg-agent over ssh-agent.  Do this before doupdate or else
	# it'll prompt for the SSH passphrase rather than the keyring passphrase
	# https://eklitzke.org/using-gpg-agent-effectively
	if [[ "undefined" == "${SSH_AUTH_SOCK:-undefined}" ]]; then
		export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	fi
	export GPG_TTY=$(tty)
fi

if [[ -e "${DOTFILES_DIR}/doupdate.sh" && ! "$(hostname)" =~ sync* ]]; then
	# Update the dotfiles repo to make sure we have all changes:
	"${DOTFILES_DIR}/doupdate.sh"
fi

# Uncomment if I want history shared across all terminals
# setopt histignorealldups sharehistory
setopt no_share_history
#unsetopt share_history

# Keep 1000 lines of history within the shell and save it to ${HOME}/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="${HOME}/.zsh_history"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# On the WSL, it's handy to use Windows $env:temp space
WSL_TEMP_GUESS=${HOME}/tmp
if [[ -O ${WSL_TEMP_GUESS} && -d ${WSL_TEMP_GUESS} ]]; then
	TMPDIR="${WSL_TEMP_GUESS}"
fi

# Adjust the path
if [[ -e "${HOME}/.pathrc" ]]; then
	source "${HOME}/.pathrc"
fi

declare WSL_VERSION=0
if [[ -e "${DOTFILES_DIR}/detect_wsl_version.sh" ]]; then
	WSL_VERSION="$(${DOTFILES_DIR}/detect_wsl_version.sh)"
fi

declare IN_DOCKER=0
if [[ -e "${DOTFILES_DIR}/detect_docker.dot" ]]; then
	source "${DOTFILES_DIR}/detect_docker.dot"
	IN_DOCKER="$(detect_docker)"
fi

if [[ -e "${HOME}/.zplug" ]]; then
	source "${HOME}/.zplug/init.zsh"

	# Bundles from robbyrussell's oh-my-zsh.
	zplug "plugins/git", from:oh-my-zsh

	zplug "plugins/command-not-found", from:oh-my-zsh
	zplug "lib/directories", from:oh-my-zsh          # Provides the directory stack

	zplug "lib/history", from:oh-my-zsh              # Provides history management

	if [[ -e "${LINUXBREWHOME}/.linuxbrew/share/zsh/site-functions" ]]; then
		fpath+=("${LINUXBREWHOME}/.linuxbrew/share/zsh/site-functions")
	fi

	if [[ "1" == "${WSL_VERSION}" ]]; then
		# Pure Prompt https://github.com/sindresorhus/pure
		fpath+=('/usr/local/lib/node_modules/pure-prompt/functions')

		zplug "akarzim/zsh-docker-aliases"

		ZSH_THEME=""
		zplug "mafredri/zsh-async", from:github
		zplug "sindresorhus/pure," use:pure.zsh, from:github, as:theme
	elif [[ "$(uname -o)" == Android || "$(uname -a)" =~ aarch64 ]]; then
		# Pure Prompt https://github.com/sindresorhus/pure
		fpath+=('/usr/local/lib/node_modules/pure-prompt/functions')

		zplug "lib/completion", from:oh-my-zsh           # Provides completion of dot directories
		# zplug "plugins/vi-mode", from:oh-my-zsh

		ZSH_THEME=""
		zplug "mafredri/zsh-async", from:github
		zplug "sindresorhus/pure," use:pure.zsh, from:github, as:theme
	else
		zplug "lib/completion", from:oh-my-zsh           # Provides completion of dot directories
		zplug "plugins/vi-mode", from:oh-my-zsh
		zplug "akarzim/zsh-docker-aliases"

		zplug "lib/theme-and-appearance", from:oh-my-zsh # Provides auto cd, and some other appearance things

		# Syntax highlighting bundle.
		zplug "zsh-users/zsh-syntax-highlighting"


		# Load the theme.
		# zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
		# zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
		DRACULA_DISPLAY_TIME=1
		DRACULA_DISPLAY_CONTEXT=1
		zplug "dracula/zsh", use:dracula.zsh-theme
	fi

	# Bookmarks in fzf
	if [[ "1" == "$(_exists fzf)" ]]; then
		zplug "uvaes/fzf-marks"
	fi

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

if [[ "1" == $(_exists urxvt) ]]; then
	# Set the terminal to urxvt, for i3wm:
	export TERMINAL=urxvt
fi

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

# Beginning/end of line
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# Alises
if [ -e "${DOTFILES_DIR}/.bash_aliases" ]; then
	source "${DOTFILES_DIR}/.bash_aliases"
elif [ -e "${HOME}/.bash_aliases" ]; then
	source "${HOME}/.bash_aliases"
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

	module use ${HOME}/.modulefiles
fi;

if [[ "khea" == "$(hostname)" ]]; then
	# Not using conan at the moment
	# export CONAN_SYSREQUIRES_MODE=disabled CONAN_SYSREQUIRES_SUDO=0

	# export DEFAULT_PYTHON_VENV="ford"

	# module load modules
	module load khea \
		ford/sync
	# module load bona

elif [[ "ugc15x24r53" == "$(hostname)" ]]; then
	# Ford Desktop
	module load ford/sync

elif [[ "sync-android" == "$(hostname)" ]]; then

	module load sync

elif [[ "WGC1CV2JWQP13" == "$(hostname)" ]]; then
	# Ford Laptop
	export WINHOME=/c/users/mruss100

	export DISPLAY=:0

	# Use Window's Docker
	# https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly
	export DOCKER_HOST=tcp://localhost:2375

	# module load ford/ford

elif [[ "$(uname -o)" = Android ]]; then
	# Likely in Termux
	# export DISPLAY=":1"
fi

# Load default python virtual env.
if [[ "undefined" == "${DEFAULT_PYTHON_VENV:-undefined}" ]]; then
	DEFAULT_PYTHON_VENV="default"
fi

# The issue is that tmux copies my path, which includes the python venv, so
# this test always passes once in tmux even when I'm not in a proper venv
declare INVENV=$(python3 -c "import sys; sys.stdout.write('1') if (hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix)) else sys.stdout.write('0')")
if [[ 0 == "${INVENV}" ]]; then
	declare python_venv="${HOME}/.virtualenvs/${DEFAULT_PYTHON_VENV}"
	if [[ -e "${python_venv}/bin" ]]; then
		source "${python_venv}/bin/activate"
	fi
fi

# direnv
if [[ "1" == "$(_exists direnv)" ]]; then
	eval "$(direnv hook zsh)"
fi

# vcpkg
if [[ -e "${VCPKG_ROOT}/scripts/vcpkg_completion.bash" ]]; then
	source "${VCPKG_ROOT}/scripts/vcpkg_completion.bash"
fi

if [[ "1" == "$(_exists fd)" || "1" == "$(_exists fdfind)" ]]; then
	export FZF_DEFAULT_COMMAND='fd --type f'
fi

export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vim: sw=4 sts=0 ts=4 noet ff=unix :
