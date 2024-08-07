# Check if fisher is installed, if not, install it
if status is-interactive
    if not functions -q fisher
        echo "Fisher not found, installing..."
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher update
    end
end
