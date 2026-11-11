#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh FILE" >&2
  exit 2
fi
file=$1
if [[ ! -f $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi

# Oldest first. If we moved .1 to .2 before .2 to .3, we would
# overwrite .2 and lose a backup.
rm -f "$file.3"
for n in 2 1; do
  if [[ -e $file.$n ]]; then
    mv "$file.$n" "$file.$((n + 1))"
  fi
done
cp "$file" "$file.1"

kept=0
for n in 1 2 3; do
  [[ -e $file.$n ]] && kept=$(( kept + 1 ))
done
echo "rotated $file: $kept backups kept"
