alias less="less -I --tabs=3"
alias screen="screen -e^Ff"
alias df="df -h"
alias f95="f95 -cpp -Wall -ffree-line-length-none -Wtabs"
if [[ "$(hostname)" != "pontus.cee.carleton.ca" ]]; then
	alias ls="ls --color=auto -lAhtrF"
else
	alias ls="ls -lAhtrFG"
fi
alias grep="grep --color=always"

# Env Can doesn't have zsh..
alias gst="git status -uno"
alias gd="git diff -w --color"
if [[ "${TRUE_HOST}" != "" || "$(hostname)" == *siteground* ]]; then
	alias gl="git pull"
	alias gp="git push"
	alias gco="git checkout"
	alias gsta="git stash"
	alias gstp="git stash pop"
	alias gba="git branch -vr"
	alias ga="git add"
fi
#alias glog="git log --follow --name-status"

# vim : ts=3 sts=0 shiftwidth=3 noet ft=bash ffs=unix :
