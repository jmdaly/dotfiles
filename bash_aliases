alias less="less -R -I --tabs=2"
alias df="df -h"
alias tclsh="rlwrap tclsh"

function _exists() {
	local bin=${1}
	local -r _not_found_pattern="not found$"
	if [[ "$(which "${1}" 2> /dev/null)" =~ ${_not_found_pattern} ]]; then
		echo "0"
	else
		echo "1"
	fi
}

if [[ "$(_exists exa)" == 1 ]]; then
   alias ls="exa --header --long --sort=newest --tree --all --level=1"
else
   alias ls="ls -lAhtrFG --color=auto"
fi
if [[ "$(_exists htop)" == 1 ]]; then
   alias htop=ytop
fi
if [[ "$(_exists dust)" == 1 ]]; then
   alias du=dust
fi
if [[ "$(_exists fd)" == 0 && "$(_exists fdfind)" == 1 ]]; then
   alias fd=fdfind
fi
if [[ "$(_exists bat)" == 0 && $(_exists batcat) == 1 ]]; then
   alias cat=batcat
elif [[ "$(_exists bat)" == 1 ]]; then
   alias cat=bat
fi
if [[ "$(_exists ag)" == 1 ]]; then
   alias ag="ag -iU --color-line-number 34 --color-path 31"
fi
alias vi=vim
if [[ $(exists nvim) == 1 ]]; then
    alias vimdiff="vim -d"
fi

alias grep="grep --color=always --exclude-dir={.git}"

# Test for Yubi
if [[ -e "${HOME}/bin/yubioath-desktop-5.0.1-linux.AppImage" ]]; then
   alias yubiAuth="${HOME}/bin/yubioath-desktop-5.0.1-linux.AppImage"
fi

# A better test would be whether I'm running zsh..
if [[ $0 == *bash || "" != "${TRUE_HOST}" || "$(hostname)" == *siteground* ]]; then
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
if [[ "${HOME}" == *com.termux* ]]; then
   alias vi="nvim"
   alias vim="nvim"
fi
alias gst="git status -uno -sb"
alias gd="git diff -w --color"

alias rs="repo sync -j8 -q -c --no-tags"

function vigd() {
    local remote=${1:-fnv}; shift
    local branch=${2:-$(git_current_branch)}
    vi -p $(git diff --name-only "${branch}" "$(git merge-base "${branch}" "${remote}")")
}

# alias glog="git log --follow --name-status"

if [[ -e ~/.bash_aliases.local ]]; then
   source ~/.bash_aliases.local
fi

alias vm="ssh vagrant@127.0.0.1 -p 2222"

# GPG aliases.. Needed until I understand GPG better
alias gpg-fixtty="gpg-connect-agent updatestartuptty /bye"
alias gpg-reload="gpg-connect-agent reloadagent /bye"

# Windows Terminal Settings (TODO I think this moved again, settings.json now or something)
# alias edit_windows_terminal="vi /c/Users/matthew.russell/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/profiles.json"

alias pwsh="pwsh -ExecutionPolicy ByPass"
alias powershell.exe="powershell.exe -ExecutionPolicy ByPass"

# vim: ts=3 sts=0 sw=3 noet ft=sh ff=unix :
