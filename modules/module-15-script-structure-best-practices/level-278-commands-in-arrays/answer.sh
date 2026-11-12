#!/usr/bin/env bash
# File finder for the support desk: solution.sh DIR [PATTERN...]
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: solution.sh DIR [PATTERN...]" >&2
  exit 2
fi

dir=$1
shift

# Each array element is exactly one word of the final command, so a pattern like
# 'Q3 *' is passed to find as a single argument, untouched by the shell.
args=(find "$dir" -type f)

if [ "$#" -gt 0 ]; then
  args+=( '(' )                 # find's own grouping parenthesis, quoted for the shell
  first=1
  for p in "$@"; do
    if [ "$first" -eq 0 ]; then
      args+=( -o )
    fi
    args+=( -name "$p" )
    first=0
  done
  args+=( ')' )
fi

"${args[@]}" | sort
