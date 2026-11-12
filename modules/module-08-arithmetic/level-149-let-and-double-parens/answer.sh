#!/usr/bin/env bash
# No "set -e" here: `let` and `(( ))` return status 1 when the result is 0,
# and this script wants to look at that status instead of dying from it.
set -uo pipefail

total="$1"
used="$2"

# let takes ordinary words, so the expression is quoted to keep the spaces
# from splitting it into separate arguments.
let "free = total - used"
let_status=$?          # $? is overwritten by every command: capture it now

# The modern form: (( )) needs no quotes and reads like normal maths.
(( used_pct = used * 100 / total ))

echo "free=$free"
echo "used_pct=$used_pct"
echo "let_status=$let_status"
