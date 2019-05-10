#!/bin/bash

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

if [[ "$1" == "" ]]; then
	if [[ "${WIN_HOME:-undefined}" == "undefined" ]]; then
		h=${HOME}
	else
		h=${WIN_HOME}
	fi
else
	h=$1
fi;
echo "Using home: $h"

if [[ "$2" == "" ]]; then
	copy=0
else
	copy=1
fi;

set -x
if [[ "$(which realpath)" == "" ]]; then
	echo "Cannot find realpath.  Use apt-get to install it"
	declare base=${h}/dotfiles
	#exit 1;
else
	declare base=${h}/dotfiles
fi;

# First ensure that the submodules in this repo
# are available and up to date:
if [[ "$(uname -o)" != "Cygwin" ]]; then
	cd ${base}
	git submodule init
	git submodule update
fi
cd ${h}

#
# Declare the files that we always want to copy over.
declare -a files;
files=(.bash_aliases)
if [[ "${TRUE_HOST}" != "" ]]; then
	# We're on env can machines
	files+=(.pathrc .vncrc .gdbinit)
elif [[ "$(uname -o)" == "Cygwin" ]]; then
	# Do nothing
	files+=(.zshrc)
else
	files+=(.zshrc .bashrc .bash_profile .profile .login .logout .modulefiles .vncrc .gdbinit .dircolors)

	mkdir -p ${h}/.local/share/fonts
	# Install fonts
	if [[ "$(ls ${h}/.local/share/fonts | grep powerline | wc -l)" -lt 3 ]]; then
		git clone https://github.com/powerline/fonts.git /tmp/powerline_fonts
		/tmp/powerline_fonts/install.sh
	fi
	# apt-get install ttf-ancient-fonts -y
	# install http://input.fontbureau.com/download/  and http://larsenwork.com/monoid/ Hack the powerline font install script to mass install 
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
		src=$f
	fi;
	if [[ ! -h ${h}/$f ]]; then
		if [[ -e ${h}/$f && -e ${base}/${src} && ! -h ${h}/${f} ]]; then
			echo "Backing up $f"
			mv ${h}/$f ${backup_dir}/$f
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
if [[ "" != "$(which nvim)" ]]; then
	# neovim is installed
	if [[ ! -e "${h}/.config/nvim" ]]; then
		mkdir -p "${h}/.config/nvim"
	fi
	if [[ -e ${h}/.vimrc ]]; then
		ln -fs ${h}/.vimrc ${h}/.config/nvim/init.vim
	fi

	# Install dein
	if [[ ! -e "${h}/dotfiles/bundles/dein" ]]; then
		curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/installer.sh
		sh /tmp/installer.sh ${h}/dotfiles/bundles/dein
	fi
fi

if [[ -e .modulefiles && ! -L .modulerc ]]; then
	ln -s .modulefiles/.modulerc ./
fi

# Install fzf
if [[ ! -e ${h}/.fzf ]]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ${h}/.fzf
	${h}/.fzf/install
fi

# Can no longer to this as I'm typically using zsh
# and this is writting in bash.  I have to keep it
# in bash in order to have it on CMC machines
#cd ${h} && source .zshrc

# vim: ts=3 sw=3 sts=0 noet :
