function __loc_get_commit_from_revset
    set revset
    if test -n "$argv[1]"
        set revset -r "$argv[1]"
    end

    # We use commit_id (full) to ensure cloc receives a precise hash
    jj log $revset \
        -T 'commit_id ++ "\n"' \
        --no-graph
end

function __loc_get_commit
    set commit (__loc_get_commit_from_revset "$argv[1]")
    if test $status -ne 0 -o -z "$commit"
        return 1
    end

    # Handle multiple revisions by failing gracefully, similar to jd.fish
    if test (count $commit) -gt 1
        jj --color=always show "$argv[1]"
        return 1
    end

    echo $commit
end

function __loc_show_help
    echo "Usage: loc [options] [<ref>]"
    echo
    echo "Options:"
    echo "  -f, --from <ref>   Start cloc diff from this revision"
    echo "  -t, --to <ref>     End cloc diff at this revision"
    echo "  -h, --help         Show this help message"
    echo
    echo "Examples:"
    echo "  loc                     Count lines in diff of current commit (vs parent)"
    echo "  loc <ref>               Count lines in diff of specific commit (vs parent)"
    echo "  loc --from a --to b     Count lines in diff between two commits"
end

function loc
    if contains -- --help $argv; or contains -- -h $argv
        __loc_show_help
        return 0
    end

    # Setup argument parsing matching jd.fish structure
    set -l options (fish_opt --short=f --long=from --required-val)
    set options $options (fish_opt --short=t --long=to --required-val)

    argparse $options -- $argv
    or return

    set -l from_commit
    set -l to_commit

    # Logic to resolve --from and --to arguments
    if set -q _flag_from
        set from_commit (__loc_get_commit $_flag_from)
        if test $status -ne 0 -o -z "$from_commit"
            return 1
        end
    else
        if set -q _flag_to
            set from_commit (__loc_get_commit "@")
            if test $status -ne 0 -o -z "$from_commit"
                return 1
            end
        end
    end

    if set -q _flag_to
        set to_commit (__loc_get_commit $_flag_to)
        if test $status -ne 0 -o -z "$to_commit"
            return 1
        end
    else
        if set -q _flag_from
            set to_commit (__loc_get_commit "@")
            if test $status -ne 0 -o -z "$to_commit"
                return 1
            end
        end
    end

    # Handle positional argument if flags weren't used exclusively
    if not set -q _flag_from; and not set -q _flag_to
        if test -n "$argv[1]"
            set to_commit (__loc_get_commit "$argv[1]")
        else
            set to_commit (__loc_get_commit "@")
        end
        
        if test $status -ne 0 -o -z "$to_commit"
            return 1
        end
        
        # If we only have a single commit (no range), we compare against its parent
        if test -z "$from_commit"
             set from_commit (__loc_get_commit "$to_commit-")
        end
    end

    # Ensure we have both sides of the diff
    if test -z "$from_commit" -o -z "$to_commit"
        echo "Error: Could not resolve start or end commits."
        return 1
    end

    echo "Running cloc --diff $from_commit $to_commit"
    cloc --diff $from_commit $to_commit
end
