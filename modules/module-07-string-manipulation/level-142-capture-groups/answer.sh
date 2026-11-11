#!/usr/bin/env bash
set -euo pipefail

# Three capture groups, numbered by their opening parenthesis:
#   1 = METHOD (capital letters)   2 = PATH (no spaces)   3 = status (3 digits)
# The text between them is matched but not captured.
re='"([A-Z]+) ([^ ]+) HTTP/[0-9.]+" ([0-9]{3}) '

while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $re ]]; then
    # BASH_REMATCH[0] is the whole match; [1], [2], [3] are the groups.
    echo "${BASH_REMATCH[3]} ${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
  else
    echo "skipped: $line"
  fi
done
