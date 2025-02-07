if status is-interactive
    if type -q jj
        jj util completion fish | source
    end
end
