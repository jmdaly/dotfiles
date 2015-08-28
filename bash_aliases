alias less="less -I --tabs=3"
alias screen="screen -e^Ff"
alias df="df -h"
alias f95="f95 -cpp -Wall -ffree-line-length-none -Wtabs"
alias ls="ls --color=auto -lhtrF"
#alias gvim="gvim -f"

# Env Can doesn't have zsh..
alias gst="git status -uno"
alias gd="git diff -w --color"

# A better test would be whether I'm running zsh..
if [[ "${TRUE_HOST}" != "" || "$(hostname)" == *siteground* ]]; then
	alias gl="git pull"
	alias gp="git push"
	alias ga="git add"
	alias gco="git checkout"
	alias gba="git branch -v"
	alias gcp="git cherry-pick"
fi
alias glog="git log --follow --name-status"
