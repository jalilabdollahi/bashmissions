#!/usr/bin/env bash
# Description: Print the number of lines in a file given as the first argument.
# Usage: count-lines.sh FILE

# -e stop on failure, -u unset variable is an error, pipefail: a pipeline fails
# if any stage fails (so a missing file in "cat" is not hidden by "wc").
set -euo pipefail

n=$(cat "$1" | wc -l | tr -d ' ')
echo "lines: $n"
echo "done"
