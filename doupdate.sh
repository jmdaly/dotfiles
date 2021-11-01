#!/bin/zsh

trap "abort_update" 1 2 3 6

function abort_update() {
    echo "Aborting dotfiles update"
}

function update_dotfiles()
{
    cd $(dirname $(realpath $0))

    local -r now=$(date +%s)
    if [[ ! -e last_check ]]; then
        echo 0 > last_check
    fi
    local last_update=$(cat last_check)
    if [[ "" == "${last_update}" ]]; then
        last_check=0
    fi;

    # Three days
    local -r s=$(expr $last_update + 259200)
    if [[ $now -gt $s ]]; then
        echo "Checking for update to dotfiles...."
        GIT_DIR=${DOTFILES_DIR:-~/dotfiles}/.git GIT_WORK_TREE=${DOTFILES_DIR:-~/dotfiles/} git pull
        echo $now > last_check
    else
        # echo "Not checking for update to dotfiles...."
    fi;
}

update_dotfiles
