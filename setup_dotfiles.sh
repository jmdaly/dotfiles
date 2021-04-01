#!/bin/bash

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

if [[ "${WINHOME:-undefined}" == "undefined" ]]; then
	h="${HOME}"
else
	h="${WINHOME}"
fi

declare -r DOTFILES_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${DOTFILES_DIR}/detect_docker.dot"
source "${DOTFILES_DIR}/rclib.dot"
source "${DOTFILES_DIR}/lib.dot"

ARGUMENT_STR_LIST=(
	"home"
)
ARGUMENT_FLAG_LIST=(
	"skip-powerline"
	"skip-fzf"
	"skip-python-venv"
	"skip-tmux"
	"skip-submodules"
	"skip-dein"
	"skip-zplug"
	"skip-rofi"
	"skip-i3"
	"skip-gnupg"
	"skip-cargo"
	"small"
)

# read arguments
opts=$(getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_STR_LIST[@]}")$(printf "%s," "${ARGUMENT_FLAG_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)
eval set --$opts

declare skip_powerline=0
declare skip_python_venv=0
declare skip_fzf=0
declare skip_tmux=0
declare skip_submodules=0
declare skip_dein=0
declare skip_zplug=0
declare skip_rofi=0
declare skip_i3=0
declare skip_gnupg=0
declare skip_cargo=0
declare copy=0 # This hasn't been used in years, it's only for cygwin/issues with symlinks with Windos
while [[ "" != $1 ]]; do
	case "$1" in
	"--home")
		shift
		h=$1
		;;
	"--skip-powerline")
		skip_powerline=1
		;;
	"--skip-python-venv")
		skip_python_venv=1
		;;
	"--skip-fzf")
		skip_fzf=1
		;;
	"--skip-tmux")
		skip_tmux=1
		;;
	"--skip-submodules")
		skip_submodules=1
		;;
	"--skip-dein")
		skip_dein=1
		;;
	"--skip-zplug")
		skip_zplug=1
		;;
	"--skip-rofi")
		skip_rofi=1
		;;
	"--skip-i3")
		skip_i3=1
		;;
	"--skip-gnupg")
		skip_gnupg=1
		;;
	"--skip-cargo")
		skip_cargo=1
		;;
	"--small")
		skip_tmux=1
		skip_fzf=1
		skip_python_venv=1
		skip_powerline=1
		skip_submodules=1
		skip_dein=1
		skip_rofi=1
		skip_i3=1
		skip_gnupg=1
		skip_cargo=1
		;;
	"--")
		shift
		break
		;;
	esac
	shift
done

echo "Using home: ${h}"

declare -r backup_dir="${h}/.dotfiles_backup"
declare DFTMP="$(mktemp -d)"
declare VENVS="${h}/.virtualenvs"

# First ensure that the submodules in this repo
# are available and up to date:
if [[ ! "1" == "${skip_submodules}" ]]; then
	cd "${DOTFILES_DIR}"
	git submodule init
	git submodule update
fi

cd "${h}"

#
# TODO deal with Windows Terminal, PS, etc, files
# TODO Create a function to mkdir.. I do that a lot here.
#

#
# Declare the files that we always want to copy over.
declare -a stows;
stows+=(zsh bash vnc gdb dircolors neovim vim tmux git p10k env-modules procs)

if [[ "1" != "${skip_powerline}" ]]; then
	install_powerline_fonts
else
	echo "Skipped installing powerline fonts"
fi

if [[ "khea" == "$(hostname)" ]]; then
	stows!=('xinitrc')
fi
if [[ "1" != "${skip_tmux}" ]]; then
	dotfiles_install_tpm "${h}"
fi

if [[ "$(which screen)" != "" ]]; then
	stows+=('screen')
fi
if [[ "$(which sqlite3)" != "" ]]; then
	stows+=('sqlite')
fi
if [[ "$(which vncserver)" != "" || "$(which tightvncserver)" != "" ]]; then
	stows+=('vnc')
fi

# Create a backup directory:
mkdir -p "${h}/.dotfiles_backup"

cd $h

# Symlink docker config from dotfiles-secret
dotfiles_install_docker_config "${h}" "${DOTFILES_DIR}/dotfiles-secret"

dotfiles_install_netrc "${h}" "${DOTFILES_DIR}/dotfiles-secret"

if [[ "1" != "${skip_zplug}" ]]; then
	dotfiles_install_zplug "${h}" "${DFTMP}"
else
	echo "Skipped installing zplug"
fi

if [[ "1" != "${skip_rofi}" ]]; then
	stows+=('rofi')
	# dotfiles_install_rofi "${h}"
	# dotfiles_install_rofipass "${h}"
else
	echo "Skipped installing rofi"
fi

if [[ "1" != "${skip_dein}" ]]; then
	dotfiles_install_dein "${h}" "${DFTMP}"
else
	echo "Skipped installing dein"
fi

# Make sure config directory exists
mkdir -p "${h}/.config"

# Setup i3
if [[ "1" != "${skip_i3}" ]]; then
	dotfiles_install_i3 "${h}"
fi

# Setup pwsh on linux
if [[ "1" == "$(_exists pwsh)" ]]; then
	stows+=('pwsh')
fi

# Install fzf
if [[ "1" != "${skip_fzf}" ]]; then
	if [[ ! -e "${h}/.fzf" ]]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git "${h}/.fzf"
		yes | "${h}/.fzf/install"
	fi
else
	echo "Skipped installing fzf"
fi

# Setup default virtualenv
if [[ "1" != "${skip_python_venv}" ]]; then
	if [[ "${DEFAULT_PYTHON_VENV:-undefined}" == "undefined" ]]; then
		DEFAULT_PYTHON_VENV="default"
	fi

	if [[ ! -e "${VENVS}/${DEFAULT_PYTHON_VENV}" && "" != "$(which virtualenv)" ]]; then
		mkdir -p "${VENVS}"
		pushd .
		cd "${VENVS}"
		echo "Creating virtual python environment ${DEFAULT_PYTHON_VENV}"
		virtualenv -p python3 "${DEFAULT_PYTHON_VENV}"
		popd
	fi
else
	echo "Skipped setting up python virtual environments"
fi

# Cargo
if [[ "1" != "${skip_cargo}" ]]; then
	dotfiles_install_cargo "${h}"
else
	echo "Skipped installing cargo config"
fi

# GPG-Agent
if [[ "1" != "${skip_gnupg}" ]]; then
	dotfiles_install_gnupg "${h}" "${DOTFILES_DIR}/dotfiles-secret"
else
	echo "Skipped installing gnupg"
fi

if [[ ! -e "${h}/.ssh/tmp" ]]; then
	mkdir -p "${h}/.ssh/tmp"
	chmod 700 "${h}/.ssh"
fi

for s in ${stows[@]}; do
	stow -d "${DOTFILES_DIR}/stow" -t "${h}" "$s"
done

# vim: ts=3 sw=3 sts=0 ff=unix noet :
