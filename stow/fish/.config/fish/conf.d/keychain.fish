# If keychain exists, use it to manage the ssh agent
# Only do this when the login shell is fish
if string match -q '*fish' $SHELL
    if type -q keychain
        keychain --quiet --agents ssh --quick --quiet --eval | source
    end
end
