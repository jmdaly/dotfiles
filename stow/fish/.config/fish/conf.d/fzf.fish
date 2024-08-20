if status is-interactive
    if type -q fzf
        fzf --fish | source
    end
end
