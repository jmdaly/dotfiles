#!/bin/zsh

cd $(dirname $(realpath $0))

now=$(date +%s)
last_update=$(cat last_check)
if [[ $last_update == "" ]]; then
	last_update=0
fi;
# Three days
s=$(expr $last_update + 259200)
if [[ $now > $s ]]; then
	echo "Checking for update to dotfiles...."
	GIT_DIR=~/dotfiles/.git GIT_WORK_TREE=~/dotfiles git pull
	echo $now > last_check
else
	echo "Checking for update to dotfiles...."
fi;
