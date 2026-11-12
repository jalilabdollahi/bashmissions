#!/usr/bin/env bash
# File finder for the support desk: solution.sh DIR [PATTERN...]
# Lists regular files under DIR whose name matches any pattern (all files if
# there is no pattern), sorted. The command is assembled as a string, which
# breaks as soon as a pattern contains a space or a star.
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: solution.sh DIR [PATTERN...]" >&2
  exit 2
fi

dir=$1
shift

cmd="find $dir -type f"
first=1
for p in "$@"; do
  if [ "$first" -eq 1 ]; then
    cmd="$cmd ( -name $p"
    first=0
  else
    cmd="$cmd -o -name $p"
  fi
done
[ "$first" -eq 0 ] && cmd="$cmd )"

# TODO: replace the string with an array: start with args=(find "$dir" -type f),
# add the grouped -name tests with args+=( ... ), then run "${args[@]}" | sort.
$cmd | sort
