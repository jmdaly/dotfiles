alias less="less -I --tabs=3"
alias screen="screen -e^Ff"
alias df="df -h"
alias f95="f95 -cpp -Wall -ffree-line-length-none -Wtabs"
alias tclsh="rlwrap tclsh"
if [[ "$(hostname)" != "pontus.cee.carleton.ca" ]]; then
	alias ls="ls --color=auto -lAhtrF"
else
	alias ls="ls -lAhtrFG"
fi
alias grep="grep --color=always"

# Env Can doesn't have zsh..
alias gst="git status -uno"
alias gd="git diff -w --color"

# A better test would be whether I'm running zsh..
if [[ "${TRUE_HOST}" != "" || "$(hostname)" == *siteground* ]]; then
	alias ga="git add"
	alias gb="git branch"
	alias gba="git branch -vr"
	alias gco="git checkout"
	alias gcp="git cherry-pick"
	alias gl="git pull"
	alias gp="git push"
	alias gsta="git stash"
	alias gstp="git stash pop"
	alias grh="git reset HEAD"
fi
#alias glog="git log --follow --name-status"

if [[ -e ~/.bash_aliases.local ]]; then
	source ~/.bash_aliases.local
fi

alias vm="ssh vagrant@127.0.0.1 -p 2222"

# vim : ts=3 sts=0 shiftwidth=3 noet ft=bash ffs=unix :
