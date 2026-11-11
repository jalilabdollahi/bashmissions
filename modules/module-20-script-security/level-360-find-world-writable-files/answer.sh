#!/usr/bin/env bash
# List regular files below DIR that "others" may write, then count them.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi

dir=$1
if [[ ! -d $dir ]]; then
  printf 'no such folder: %s\n' "$dir" >&2
  exit 1
fi

# -perm -002 means "bit 002 must be set, other bits don't matter".
# (Plain -perm 002 would only match a file whose mode is exactly 002.)
# mapfile -t keeps one array element per line, spaces included.
mapfile -t hits < <(find "$dir" -type f -perm -002 | sort)

for path in "${hits[@]}"; do
  printf '%s\n' "$path"
done
printf 'world-writable: %d\n' "${#hits[@]}"
