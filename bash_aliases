alias less="less -R -I --tabs=2"
alias screen="screen -e^Ff"
alias df="df -h"
alias f95="f95 -cpp -Wall -ffree-line-length-none -Wtabs"
alias tclsh="rlwrap tclsh"
alias ls="ls -lAhtrFG --color=auto"
if [[ "$(which exa 2> /dev/null)" != "" ]]; then
    alias ls="exa --header --long -s changed --tree --all --level=1"
fi
if [[ "$(which htop 2> /dev/null)" != "" ]]; then
    alias htop="ytop"
fi
if [[ "$(which dust 2> /dev/null)" != "" ]]; then
    alias du="dust"
fi
if [[ "$(which bat 2> /dev/null)" != "" ]]; then
    alias cat=bat
fi

alias grep="grep --color=always --exclude-dir={.git}"

if [[ -e /usr/bin/ag ]]; then
	alias ag="ag -iU --color-line-number 34 --color-path 31"
fi

# Env Can doesn't have zsh..
alias gst="git status -uno -sb"
alias gd="git diff -w --color"

alias vi=vim
if [[ "" != "$(which nvim)" ]]; then
	alias vimdiff="vim -d"
fi

# Test for Yubi
if [[ -e "${HOME}/bin/yubioath-desktop-5.0.1-linux.AppImage" ]]; then
	alias yubiAuth="${HOME}/bin/yubioath-desktop-5.0.1-linux.AppImage"
fi

# A better test would be whether I'm running zsh..
if [[ $0 == *bash || "${TRUE_HOST}" != "" || "$(hostname)" == *siteground* ]]; then
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
	alias gf="git fetch"
	alias grb="git rebase"
	alias grbc="git rebase --continue"
	alias gmt="git mergetool"
fi
if [[ $HOME == *com.termux* ]]; then
	alias vi="nvim"
	alias vim="nvim"
fi

alias vigd="vi -p \$(git diff --name-only topic/capi \$(git merge-base topic/capi master))"
alias make-targets="make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u"

#alias glog="git log --follow --name-status"

if [[ -e ~/.bash_aliases.local ]]; then
	source ~/.bash_aliases.local
fi

alias vm="ssh vagrant@127.0.0.1 -p 2222"

function catjson() {
	cat $1                        \
		| python -m json.tool      \
		| pygmentize -l javascript
}

# GPG aliases.. Needed until I understand GPG better
alias gpg-fixtty="gpg-connect-agent updatestartuptty /bye"
alias gpg-reload="gpg-connect-agent reloadagent /bye"

# Windows Terminal Settings
alias edit_windows_terminal="vi /mnt/c/Users/matthew.russell/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/profiles.json"

alias pwsh="pwsh -ExecutionPolicy ByPass"
alias powershell.exe="powershell.exe -ExecutionPolicy ByPass"

# vim: ts=3 sts=0 sw=3 noet ft=sh ff=unix :
