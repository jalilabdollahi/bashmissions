#!/usr/bin/env bash
# Append a note, but never through a symbolic link.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh FILE TEXT" >&2
  exit 2
fi

file=$1
text=$2
folder=$(dirname -- "$file")

# -L looks at the link itself. [[ -e ]] or [[ -f ]] would follow it, and say
# "false" for a dangling link, which >> would then happily create at the target.
if [[ -L $file ]]; then
  printf 'refusing: %s is a symlink\n' "$file" >&2
  exit 1
fi
# The folder part can be the link too: shared/x.txt with shared -> elsewhere.
if [[ -L $folder ]]; then
  printf 'refusing: %s is a symlink\n' "$folder" >&2
  exit 1
fi

printf '%s\n' "$text" >> "$file"
printf 'noted: %s\n' "$file"
