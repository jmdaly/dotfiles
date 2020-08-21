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
# TODO Create a function to mkdir and symlink.. I do that a lot here.
#

#
# Declare the files that we always want to copy over.
declare -a files;
files=(.bash_aliases)
files+=(.zshrc .pathrc .bashrc .bash_profile .profile .login .logout .modulefiles .vncrc .gdbinit .dircolors .vimrc .tmux.conf .gitconfig)

if [[ "1" != "${skip_powerline}" ]]; then
	if [[ $HOME != *com.termux* ]]; then
		# For now at least, don't install powerline fonts on termux
		mkdir -p "${h}/.local/share/fonts"
		# Install fonts
		if [[ "$(ls ${h}/.local/share/fonts | grep powerline | wc -l)" -lt 3 ]]; then
			git clone https://github.com/powerline/fonts.git "${DFTMP}/powerline_fonts"
			${DFTMP}/powerline_fonts/install.sh
		fi
		# apt-get install ttf-ancient-fonts -y
		# install http://input.fontbureau.com/download/  and http://larsenwork.com/monoid/ Hack the powerline font install script to mass install
	fi
else
	echo "Skipped installing powerline fonts"
fi


if [[ "khea" == "$(hostname)" ]]; then
	# Apple keyboard stuff.. Should detect keyboard rather than host, maybe later..
	if [[ ! -e "${DOTFILES_DIR}/xinitrc" ]]; then
		ln -s "${DOTFILES_DIR}/.xinitrc" "xinitrc"
	fi
fi

# Check if our environment supports these
if [[ "1" != "${skip_tmux}" ]]; then
	dotfiles_install_tpm "${h}"
else
	echo "Skipped setting up tmux pluggins"
fi

if [[ "$(which screen)" != "" ]]; then
	files+=('.screenrc')
fi
if [[ "$(which sqlite3)" != "" ]]; then
	files+=('.sqliterc')
fi
if [[ "$(which ctags)" != "" ]]; then
	files+=('.ctags')
fi
if [[ "$(which vncserver)" != "" || "$(which tightvncserver)" != "" ]]; then
	files+=('.vnc')
fi

# Rust "procs" tool (better ps)
dotfiles_install_tpm "${h}"

# .config/autokey

# Create a backup directory:
mkdir -p "${h}/.dotfiles_backup"

for f in ${files[@]}; do
	# Local file in dotfile fir
	if [[ $f =~ .* ]]; then
		src="${f/.//}"
	else
		src="$f"
	fi;
	if [[ ! -h "${h}/$f" ]]; then
		if [[ -e "${h}/$f" && -e "${DOTFILES_DIR}/${src}" && ! -h "${h}/${f}" ]]; then
			echo "Backing up $f"
			mv "${h}/$f" "${backup_dir}/$f"
		fi
		if [[ -e "${DOTFILES_DIR}/${src}" ]]; then
			#echo "Installing $f"
			if [[ "1" == "${copy}" ]]; then
				# On cygwin, symlinks when used through gvim
				# can be an issue.  Note, this hasn't been used in years
				cp -r "${DOTFILES_DIR}/${src}" "$f";
			else
				if [[ ! -L "$f" ]]; then
					ln -s "${DOTFILES_DIR}/${src}" "$f"
				fi
			fi;
		fi
	fi
done;

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
	dotfiles_install_rofi "${h}"
	dotfiles_install_rofipass "${h}"
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

dotfiles_install_nvim "${h}"

# Setup i3
if [[ "1" != "${skip_i3}" ]]; then
	dotfiles_install_i3 "${h}"
else
	echo "Skipped installing i3"
fi

# Setup pwsh on linux
if [[ "$(which pwsh)" != "" ]]; then
	mkdir -p "${h}/.config/powershell"
	ln -s "${DOTFILES_DIR}/profile.ps1" "${h}/.config/powershell/Microsoft.PowerShell_profile.ps1"
fi

# Setup module files
if [[ -e "${DOTFILES_DIR}/.modulefiles" && ! -L "${h}/.modulerc" ]]; then
	ln -s "${DOTFILES_DIR}/.modulefiles/.modulerc" "${h}/"
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

# vim: ts=3 sw=3 sts=0 ff=unix noet :
