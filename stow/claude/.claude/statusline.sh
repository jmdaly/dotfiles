#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

# Colorize a "label: N%" pair by usage: <70 green, <90 yellow, else red
limit_part() { # $1=label $2=percentage
    local pct=$(printf '%.0f' "$2") color="$GREEN"
    [ "$pct" -ge 70 ] && color="$YELLOW"
    [ "$pct" -ge 90 ] && color="$RED"
    printf '%s: %b%s%%%b' "$1" "$color" "$pct" "$RESET"
}

# Context window usage bar
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"
CTX_COLOR="$GREEN"
[ "$PCT" -ge 70 ] && CTX_COLOR="$YELLOW"
[ "$PCT" -ge 90 ] && CTX_COLOR="$RED"
CTX=" | $BAR ${CTX_COLOR}$PCT%${RESET}"

# Rate limits: "// empty" produces no output when absent
FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
WEEK=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
LIMITS=""
[ -n "$FIVE_H" ] && LIMITS="$(limit_part 5h "$FIVE_H")"
[ -n "$WEEK" ] && LIMITS="${LIMITS:+$LIMITS }$(limit_part 7d "$WEEK")"
[ -n "$LIMITS" ] && LIMITS=" | $LIMITS"

if jj root > /dev/null 2>&1; then
    BOOKMARK=$(jj log -r 'heads(::@ & bookmarks())' --no-graph -T 'bookmarks.join(",")' 2>/dev/null)
    [ -z "$BOOKMARK" ] && BOOKMARK="(no bookmark)"

    DIFF_SUMMARY=$(jj diff --summary -r @ 2>/dev/null)
    ADDED=$(grep -c '^A ' <<< "$DIFF_SUMMARY")
    MODIFIED=$(grep -c '^M ' <<< "$DIFF_SUMMARY")
    DELETED=$(grep -c '^D ' <<< "$DIFF_SUMMARY")

    JJ_STATUS=""
    [ "$ADDED" -gt 0 ] && JJ_STATUS="${GREEN}+${ADDED}${RESET}"
    [ "$MODIFIED" -gt 0 ] && JJ_STATUS="${JJ_STATUS}${YELLOW}~${MODIFIED}${RESET}"
    [ "$DELETED" -gt 0 ] && JJ_STATUS="${JJ_STATUS}${RED}-${DELETED}${RESET}"

    echo -e "[$MODEL] 📁 ${DIR##*/} | 🌿 $BOOKMARK $JJ_STATUS$CTX$LIMITS"
else
    echo -e "[$MODEL] 📁 ${DIR##*/}$CTX$LIMITS"
fi
