#!/bin/zsh

trap "abort_update" 1 2 3 6

function abort_update() {
    echo "Aborting dotfiles update"
}

function update_dotfiles()
{
    cd $(dirname $(realpath $0))
    local check_file=${DOTFILES_DIR:-$(dirname "$(realpath "$0")")}/.last_check

    local -r now=$(date +%s)
    if [[ ! -e "${check_file}" ]]; then
        echo 0 > "${check_file}"
    fi
    local last_update=$(cat ${check_file})
    if [[ "" == "${last_update}" ]]; then
        last_check=0
    fi;

    # Three days
    local -r s=$(expr $last_update + 259200)
    if [[ $now -gt $s ]]; then
        echo "Checking for update to dotfiles...."
        GIT_DIR=${DOTFILES_DIR:-~/dotfiles}/.git GIT_WORK_TREE=${DOTFILES_DIR:-~/dotfiles/} git pull
        echo $now > "${check_file}"
    else
        # echo "Not checking for update to dotfiles...."
    fi;
}

update_dotfiles
