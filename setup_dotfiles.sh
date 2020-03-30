#!/bin/bash

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

if [[ "${WINHOME:-undefined}" == "undefined" ]]; then
	h="${HOME}"
else
	h="${WINHOME}"
fi

declare -r DOTFILES_DIR="$(dirname $0)"

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
	"--small")
		skip_tmux=1
		skip_fzf=1
		skip_python_venv=1
		skip_powerline=1
		skip_submodules=1
		skip_dein=1
		skip_zplug=1
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

# I don't think I've used this in years.  WSL removes the need
if [[ "$2" == "" ]]; then
	copy=0
else
	copy=1
fi;

# TODO Is there an alternative to realpath?
if [[ "" == "$(which realpath)" ]]; then
	echo "Cannot find realpath.  Use apt-get to install it"
	declare base="${h}/dotfiles"
	#exit 1;
else
	declare base="${h}/dotfiles"
fi;

# First ensure that the submodules in this repo
# are available and up to date:
if [[ ! "1" == "${skip_submodules}" ]]; then
	cd ${base}
	git submodule init
	git submodule update
fi

cd ${h}

#
# TODO deal with Windows Terminal, PS, etc, files
# TODO Create a function to mkdir and symlink.. I do that a lot here.
# TODO Make dotfiles secret a module, and add a section here to link the files there, add keys, etc.  Or at least make the config file point to some identify files in the dotfiles-secret clone
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

# Check if our environment supports these
if [[ "1" != "${skip_tmux}" ]]; then
	if [[ "$(which tmux)" != "" ]]; then
		mkdir -p "${h}/.tmux/plugins"
		git clone https://github.com/tmux-plugins/tpm "${h}/.tmux/plugins/tpm"
	fi
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
if [[ "$(which vncserver)" != "" ]]; then
	files+=('.vnc')
fi

# .config/autokey

# Create a backup directory:
mkdir -p "${h}/.dotfiles_backup"

for f in ${files[@]}; do
	# Local file in dotfile fir
	if [[ $f =~ .* ]]; then
		src=${f/.//}
	else
		src="$f"
	fi;
	if [[ ! -h "${h}/$f" ]]; then
		if [[ -e ${h}/$f && -e "${base}/${src}" && ! -h "${h}/${f}" ]]; then
			echo "Backing up $f"
			mv "${h}/$f" "${backup_dir}/$f"
		fi
		if [[ -e ${base}/${src} ]]; then
			#echo "Installing $f"
			if [[ "$copy" == 1 ]]; then
				# On cygwin, symlinks when used through gvim
				# can be an issue
				cp -r ${base}/${src} $f;
			else
				if [[ ! -L $f ]]; then
					ln -s ${base}/${src} $f
				fi
			fi;
		fi
	else
		echo "Skipping symlink $f"
	fi
done;

cd $h

# Install zplug
if [[ "1" != "${skip_zplug}" ]]; then
	if [[ ! -e "${h}/.zplug" ]]; then
		curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh > "${DFTMP}/install_zplug.sh"
		if [[ $? == 0 ]]; then
			zsh "${DFTMP}/install_zplug.sh"
		else
			echo "Couldn't download zplug installer.  Is there a proxy blocking it?  Proxy env is:"
			env | grep -i proxy
		fi
	fi
fi

# Install dein
if [[ "1" != "${skip_dein}" ]]; then
	if [[ ! -e "${DOTFILES_DIR}/dotfiles/bundles/dein" ]]; then
		curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > "${DFTMP}/install_dein.sh"
		if [[ $? == 0 ]]; then
			sh "${DFTMP}/install_dein.sh" "${DOTFILES_DIR}/dotfiles/bundles/dein"
		else
			echo "Couldn't download dein installer.  Is there a proxy blocking it?  Proxy env is:"
			env | grep -i proxy
		fi
	fi
else
	echo "Skipped installing dein"
fi

# Setup nvim config, whether it's currently installed or not
mkdir -p "${h}/.config/nvim"
if [[ -e "${h}/.vimrc" ]]; then
	ln -fs "${h}/.vimrc" "${h}/.config/nvim/init.vim"
fi
ln -fs "${DOTFILES_DIR}/dotfiles/config/nvim/spell" "${h}/.config/nvim/spell"

# Setup pwsh on linux
mkdir -p "${h}/.config/powershell"
ln -sf "${DOTFILES_DIR}/profile.ps1" "${h}/.config/powershell/Microsoft.PowerShell_profile.ps1"

# Setup i3
mkdir -p "${h}/.config/i3"
ln -sf "${DOTFILES_DIR}/i3/config" "${h}/.config/i3/config"

if [[ -e .modulefiles && ! -L "${h}/.modulerc" ]]; then
	ln -s .modulefiles/.modulerc "${h}/"
fi

# Install fzf
if [[ "1" != "${skip_fzf}" ]]; then
	if [[ ! -e "${h}/.fzf" ]]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git ${h}/.fzf
		yes | ${h}/.fzf/install
	fi
else
	echo "Skipped installing fzf"
fi

# Setup default virtualenv
if [[ "1" != "${skip_python_venv}" ]]; then
	if [[ ! -e "${VENVS}/default" && "" != "$(which virtualenv)" ]]; then
		mkdir -p "${VENVS}"
		pushd .
		cd "${VENVS}"
		virtualenv -p python3 default
		popd
	fi
else
	echo "Skipped setting up python virtual environments"
fi

# GPG-Agent
if [[ ! -e "${h}/.gnupg/gpg-agent.conf" ]]; then
	mkdir -p "${h}/.gnupg"
	if [[ ! -e "${h}/.gnupg/gpg-agent.conf" ]]; then
		ln -sf "${DOTFILES_DIR}/gpg-agent.conf" "${h}/.gnupg/gpg-agent.conf"
	fi;
fi

if [[ ! -e "${h}/.ssh/tmp" ]]; then
	mkdir -p "${h}/.ssh/tmp"
	chmod 700 "${h}/.ssh"
fi

# vim: ts=3 sw=3 sts=0 ff=unix noet :
