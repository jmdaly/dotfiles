# Create and switch to a directory in one command
function mdcd
    mkdir $argv[1]
    and cd $argv[1]
end
