function __get_commit_from_revset
    set revset
    if test -n "$argv[1]"
        set revset -r "$argv[1]"
    end

    jj log $revset \
        -T 'commit_id.short() ++ "\n"' \
        --no-graph
end

function __get_commit
    set commit (__get_commit_from_revset "$argv[1]")
    if test $status -ne 0 -o -z "$commit"
        return 1
    end

    # This is a fun little detail.
    #
    # When the revset resolves to more than one commit we want to fail because
    # this tool only works with singular revisions.
    #
    # To handle this failure we shell out to `jj show` which has the same
    # requirement (single revision revsets) but it will show a pretty error. So
    # we get that for free :)
    if test (count $commit) -gt 1
        jj --color=always show "$argv[1]"
        return 1
    end

    echo $commit
end

function __is_empty
    test (jj log -r "$argv[1]" -T 'empty' --no-graph) = true
end

function __show_help
    echo "Usage: jd [options] [<ref>]"
    echo
    echo "Options:"
    echo "  -f, --from <ref>   Start diff from this revision"
    echo "  -t, --to <ref>     End diff at this revision"
    echo "  -s, --split        Split the diff by commit"
    echo "  -S, --symmetric    View the symmetric difference (a...b)"
    echo "  -h, --help         Show this help message"
    echo
    echo "Examples:"
    echo "  jd                           Show diff of current commit"
    echo "  jd <ref>                     Show diff of specific commit"
    echo "  jd --from a                  Show diff from <ref> to current"
    echo "  jd --to a                    Show diff of specific commit"
    echo "  jd --from a --to b           Show diff between two commits"
    echo "  jd --from a --to b --split   Show diff of each commit between a and b"
end

# This is a super useful little function which allows me to run something like
# `jd xowwtltt` and open the diff in a Neovim Diffview window.
#
# In other words this acts like a superior version of `jj diff` which allows
# viewing the diff interactively in Neovim instead of having to use a pager.
function jd
    if contains -- --help $argv; or contains -- -h $argv
        __show_help
        return 0
    end

    set -l options (fish_opt --short=f --long=from --required-val)
    set options $options (fish_opt --short=t --long=to --required-val)
    set options $options (fish_opt --short=s --long=split)
    set options $options (fish_opt --short=S --long=symmetric)

    argparse $options -- $argv
    or return

    set -l from_commit
    set -l to_commit

    # Handle --from and --to arguments
    if set -q _flag_from
        set from_commit (__get_commit $_flag_from)
        if test $status -ne 0 -o -z "$from_commit"
            return 1
        end
    else
        if set -q _flag_to
            set from_commit (__get_commit "@")
            if test $status -ne 0 -o -z "$from_commit"
                return 1
            end
        end
    end

    if set -q _flag_to
        set to_commit (__get_commit $_flag_to)
        if test $status -ne 0 -o -z "$to_commit"
            return 1
        end
    else
        if set -q _flag_from
            set to_commit (__get_commit "@")
            if test $status -ne 0 -o -z "$to_commit"
                return 1
            end
        end
    end

    # Handle positional argument if present
    if not set -q _flag_from; and not set -q _flag_to
        if test -n "$argv[1]"
            set to_commit (__get_commit "$argv[1]")
        else
            set to_commit (__get_commit "@")
        end
        if test $status -ne 0 -o -z "$to_commit"
            return 1
        end
    end

    set -l diff_range

    # Construct diff range based on provided arguments
    if test -n "$from_commit" -a -n "$to_commit"
        if set -q _flag_symmetric
            set diff_range "$from_commit...$to_commit"
        else
            set diff_range "$from_commit..$to_commit"
        end
    else if test -n "$to_commit"
        if __is_empty $to_commit
            echo "Empty revision. No changes to show."
            return 0
        end
        set diff_range "$to_commit^!"
    end

    if set -q _flag_split
        nvim -c "DiffviewFileHistory --range=$diff_range --right-only --no-merges"
    else
        nvim -c "DiffviewOpen $diff_range"
    end
end
