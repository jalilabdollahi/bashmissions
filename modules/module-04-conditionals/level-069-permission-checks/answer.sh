#!/usr/bin/env bash
set -euo pipefail

path="$1"

if [[ ! -e $path ]]; then
  echo "no such file: $path" >&2
  exit 1
fi

# Each right starts as "-" and is upgraded to its letter when the test passes.
# These tests ask about the user running the script, not about the file's mode bits.
r="-"
w="-"
x="-"

if [[ -r $path ]]; then r="r"; fi
if [[ -w $path ]]; then w="w"; fi
if [[ -x $path ]]; then x="x"; fi

echo "$path: $r$w$x"
