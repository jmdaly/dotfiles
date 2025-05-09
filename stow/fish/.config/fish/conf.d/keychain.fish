# If keychain exists, use it to manage the ssh agent
# Only do this when the login shell is fish
if status is-interactive
    if string match -q '*fish' $SHELL
        if type -q keychain
            keychain --quick --quiet --eval | source
        end
    end
end
