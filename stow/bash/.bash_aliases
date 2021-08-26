if [[ "undefined" == "${DOTFILES_DIR:-undefined}" ]]; then
	export DOTFILES_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
fi
if ! typeset -f _exists > /dev/null ; then
	if [[ -e "${DOTFILES_DIR}/rclib.dot" ]]; then
		source "${DOTFILES_DIR}/rclib.dot"
	fi
fi

alias df="df -h"
alias tclsh="rlwrap tclsh"

if [[ "$(_exists exa)" == 1 ]]; then
   alias ls="exa --header --long --sort=newest --tree --all --level=1 --ignore-glob=.git"
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
   export FD_CMD=fdfind
fi
export FZF_DEFAULT_COMMAND="${FD_CMD:-fd} --type f --exclude .git --exclude out"
if [[ "$(_exists bat)" == 0 && $(_exists batcat) == 1 ]]; then
   alias cat=batcat
   alias less=batcat
elif [[ "$(_exists bat)" == 1 ]]; then
   alias cat=bat
else
   alias less="less -R -I --tabs=2"
fi
if [[ "$(_exists ag)" == 1 ]]; then
   alias ag="ag -iU --color-line-number 34 --color-path 31"
fi
alias vi=vim
if [[ $(_exists nvim) == 1 ]]; then
    alias vimdiff="vim -d"
fi

alias grep="grep --color=always --exclude-dir={.git}"

# Test for Yubi
if [[ -e "${HOME}/bin/yubioath-desktop-5.0.1-linux.AppImage" ]]; then
   alias yubiAuth="${HOME}/bin/yubioath-desktop-5.0.1-linux.AppImage"
fi

function git_current_remote() {
    # This is a hack for now, soon this should be changes to detect if we're in
    # a repo workspace and use the python manifest tools to select the proper
    # tool.
    # Currently this returns this first remote
    echo $(git remote | head -n 1)
}

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
   alias grv="git remote -v"
fi
if [[ "${HOME}" == *com.termux* ]]; then
   alias vi="nvim"
   alias vim="nvim"
fi
alias gst="git status -uno -sb"
alias rst="repo status"
alias gd="git diff -w --color"
alias gdrm='git diff $(git_current_remote)/master'
alias gdr='git diff $(git_current_remote)/$(git_current_branch)'
alias rs="repo sync -j8 -q -c --no-tags"
alias rl="repo sync -j8 -q -c --no-tags"
alias gpsup='git push --set-upstream $(git_current_remote) $(git_current_branch)'
alias ggsup='git branch --set-upstream-to=$(git_current_remote)/$(git_current_branch)'

function rebase_to_master() {
	git fetch $(git_current_remote) && \
	git rebase $(git_current_remote)/master
}

function vigd() {
    local remote=${1:-$(git_current_remote)}; shift
    local branch=${2:-$(git_current_branch)}
    vi -p $(git diff --name-only "${branch}" "$(git merge-base "${branch}" "${remote}")")
}

function repo_init_aos() {
	repo init -u ssh://git@github.ford.com/AOS/manifest -m aos-development.xml --config --partial-clone $@
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

if [[ "undefined" == "${ANDROID_BUILD_TOP:-undefined}" ]]; then
    export ANDROID_BUILD_TOP=/opt/android-src/aos
fi
alias aos-setup="source ${ANDROID_BUILD_TOP}/build/envsetup.sh && lunch alverstone-userdebug"
alias aos-gas-setup="source ${ANDROID_BUILD_TOP}/build/envsetup.sh && lunch alverstone_gas-userdebug"
alias aos-em-setup="source ${ANDROID_BUILD_TOP}/build/envsetup.sh && lunch aos_emulator_car_x86_64-userdebug"

alias apt-search="apt-cache search '' | sort | cut --delimiter ' ' --fields 1 | fzf --multi --cycle --reverse --preview 'apt-cache show {1}' | xargs -r sudo apt install -y"

alias reboot="echo no........"

alias plex-refresh="/usr/lib/plexmediaserver/Plex\ Media\ Scanner -s -v"

# vim: ts=3 sts=0 sw=3 noet ft=sh ff=unix :
