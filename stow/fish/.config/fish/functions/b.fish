function b --description 'checkout git branch (including remote branches)'
    set -l branches (git branch --all | grep -v HEAD | string split0)
    set -l branch (echo "$branches" | fzf)
    # Remove the first two characters of the branch string, which are either space or *.
    # Also, if the string "remotes/origin/" is there, remove it.
    set -l clean_branch (echo "$branch" | cut -c 3- | sed "s/remotes\/origin\///")
    git checkout "$clean_branch"
end

