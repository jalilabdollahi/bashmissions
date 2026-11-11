#!/usr/bin/env bash
set -euo pipefail

# Groups are numbered by where their "(" opens, left to right:
#   1 = major   2 = minor   3 = patch
# The dots are escaped because an unescaped . means "any character".
re='^v([0-9]+)\.([0-9]+)\.([0-9]+)$'

while IFS= read -r tag || [[ -n $tag ]]; do
  if [[ $tag =~ $re ]]; then
    echo "major=${BASH_REMATCH[1]} minor=${BASH_REMATCH[2]} patch=${BASH_REMATCH[3]}"
  else
    echo "bad tag: $tag"
  fi
done
