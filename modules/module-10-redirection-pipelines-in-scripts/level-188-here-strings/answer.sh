#!/usr/bin/env bash
set -euo pipefail
text=$1

# "<<<" gives the command the string plus a newline on stdin: no extra
# process, no pipe, and no subshell for variables set later.
words=$(( $(wc -w <<< "$text") ))
loud=$(tr 'a-z' 'A-Z' <<< "$text")

echo "words=$words"
echo "LOUD: $loud"
