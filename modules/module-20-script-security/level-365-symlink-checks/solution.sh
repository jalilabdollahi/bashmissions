#!/usr/bin/env bash
# Append a note to a customer file. Right now it happily follows symbolic links,
# so a link can redirect the write to any file the script's user may change.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh FILE TEXT" >&2
  exit 2
fi

file=$1
text=$2
# TODO: before writing, refuse when FILE is a symlink, then when the folder part
# of FILE is a symlink. Use [[ -L ... ]]; dirname gives the folder part.
printf '%s\n' "$text" >> "$file"
printf 'noted: %s\n' "$file"
