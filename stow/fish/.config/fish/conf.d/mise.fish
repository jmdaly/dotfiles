if status is-interactive
    if type -q mise
        mise activate fish | source
    end
    # Check if the `usage` command is available, which mise
    # uses to generate completions.
    if type -q usage
        mise completion fish | source
    end
end
