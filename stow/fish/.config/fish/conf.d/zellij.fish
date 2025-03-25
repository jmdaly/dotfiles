if status is-interactive
    if type -q zellij
        zellij setup  --generate-completion fish | source
    end
end
