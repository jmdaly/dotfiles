alias less="less -I --tabs=3"
alias screen="screen -e^Ff"
alias df="df -h"
alias f95="f95 -cpp -Wall -ffree-line-length-none -Wtabs"
alias ls="ls --color=auto -lhtrF"
#alias gvim="gvim -f"

# Env Can doesn't have zsh..
alias gst="git status -uno"
alias gd="git diff -w --color"
if [[ "${TRUE_HOST}" != "" ]]; then
	alias gl="git pull"
	alias gp="git push"
	alias glog="git log --name-status"
fi
