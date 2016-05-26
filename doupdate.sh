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
	GIT_DIR=~/dotfiles/.git GIT_WORK_TREE=~/dotfiles git submodule update --remote --merge

	# Update the password manager if it's set up on the current account:
	if type pass > /dev/null && [ -d ~/.password-store ]; then
		echo "Update password store..."
		pass git pull
		pass git push
	fi

	# Re-run setup in case there are new files to handle:
	~/dotfiles/setup_dotfiles.sh
	echo $now > last_check
fi;
