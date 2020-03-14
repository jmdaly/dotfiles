#!/bin/bash

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

if [[ "$1" == "" ]]; then
	if [[ "${WINHOME:-undefined}" == "undefined" ]]; then
		h=${HOME}
	else
		h=${WINHOME}
	fi
else
	h=$1
fi;
echo "Using home: $h"

declare VENVS="${h}/.virtualenvs"

# I don't think I've used this in years.  WSL removes the need
if [[ "$2" == "" ]]; then
	copy=0
else
	copy=1
fi;

if [[ "" == "$(which realpath)" ]]; then
	echo "Cannot find realpath.  Use apt-get to install it"
	declare base="${h}/dotfiles"
	#exit 1;
else
	declare base="${h}/dotfiles"
fi;

# First ensure that the submodules in this repo
# are available and up to date:
cd ${base}
git submodule init
git submodule update

cd ${h}

#
# TODO deal with Windows Terminal, Oni, PS, etc, files
#

#
# Declare the files that we always want to copy over.
declare -a files;
files=(.bash_aliases)
if [[ "${TRUE_HOST}" != "" ]]; then
	# We're on Env Can machines
	files+=(.pathrc .vncrc .gdbinit)
else
	files+=(.zshrc .pathrc .bashrc .bash_profile .profile .login .logout .modulefiles .vncrc .gdbinit .dircolors)

	if [[ $HOME != *com.termux* ]]; then
		# For now at least, don't install powerline fonts on termux
		mkdir -p ${h}/.local/share/fonts
		# Install fonts
		if [[ "$(ls ${h}/.local/share/fonts | grep powerline | wc -l)" -lt 3 ]]; then
			git clone https://github.com/powerline/fonts.git ${DFTMP}/powerline_fonts
			${DFTMP}/powerline_fonts/install.sh
		fi
		# apt-get install ttf-ancient-fonts -y
		# install http://input.fontbureau.com/download/  and http://larsenwork.com/monoid/ Hack the powerline font install script to mass install
	fi;
fi

# Check if our environment supports these
if [[ "$(which vi)" != "" ]]; then
	files+=('.vimrc')
fi
if [[ "$(which tmux)" != "" ]]; then
	files+=('.tmux.conf')
	if [[ ! -e ${h}/.tmux ]]; then
		git clone https://github.com/tmux-plugins/tpm ${h}/.tmux/plugins/tpm
	fi
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

declare backup_dir=${h}/.dotfiles_backup

# Create a backup directory:
mkdir -p ${h}/.dotfiles_backup

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
if [[ ! -e "${h}/.zplug" ]]; then
	ztmp="$(mktemp -d)"
	wget -O "${ztmp}/installer.zsh" https://raw.githubusercontent.com/zplug/installer/master/installer.zsh \
		&& zsh "${ztmp}/installer.zsh"
fi

# Install dein
if [[ ! -e "${h}/dotfiles/bundles/dein" ]]; then
	DFTMP="$(mktemp -d)"
	wget -O "${DFTMP}/installer.sh" https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh
	sh "${DFTMP}/installer.sh" "${h}/dotfiles/bundles/dein"
fi

# Setup nvim config, whether it's currently installed or not
if [[ ! -e "${h}/.config/nvim" ]]; then
	mkdir -p "${h}/.config/nvim"
fi
if [[ -e "${h}/.vimrc" ]]; then
	ln -fs "${h}/.vimrc" "${h}/.config/nvim/init.vim"
fi

if [[ ! -e "${h}/.config/powershell" ]]; then
	mkdir -p "${h}/.config/powershell"
	ln -s $(pwd)/profile.ps1 ${h}/.config/powershell/Microsoft.PowerShell_profile.ps1
fi

if [[ -e .modulefiles && ! -L "${h}/.modulerc" ]]; then
	ln -s .modulefiles/.modulerc "${h}/"
fi

# Install fzf
if [[ ! -e ${h}/.fzf ]]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ${h}/.fzf
	yes | ${h}/.fzf/install
fi

# Setup default virtualenv
if [[ ! -e "${VENVS}/default" && "" != "$(which virtualenv)" ]]; then
	mkdir -p "${VENVS}"
	pushd .
	cd "${VENVS}"
	virtualenv -p python3 default
	popd
fi

# GPG-Agent
if [[ ! -e "${h}/.gnupg/gpg-agent.conf" ]]; then
	mkdir -p "${h}/.gnupg"
	ln -fs gpg-agent.conf "${h}/.gnupg/gpg-agent.conf"
fi

if [[ ! -e "${h}/.ssh/tmp" ]]; then
	mkdir -p "${h}/.ssh/tmp"
	chmod 700 "${h}/.ssh"
fi

# vim: ts=3 sw=3 sts=0 ff=unix noet :
