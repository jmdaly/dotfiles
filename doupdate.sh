#!/bin/zsh

cd ${HOME}/dotfiles

now=$(date +%s)
if [[ ! -e last_check ]]; then
	echo 0 > last_check
fi
last_update=$(cat last_check)
if [[ $last_update == "" ]]; then
	last_check=0
fi;
# Three days
s=$(expr $last_update + 259200)
if [[ $now -gt $s ]]; then
	echo "Checking for update to dotfiles...."
	GIT_DIR=~/dotfiles/.git GIT_WORK_TREE=~/dotfiles git pull

	# Re-run setup in case there are new files to handle:
	~/dotfiles/setup.sh

	# Update the secure setup for this system,
	# if it exists:
	[ -f ~/secure-setup/setup_secure.sh ] && ~/secure-setup/setup_secure.sh

	echo $now > last_check
fi;
