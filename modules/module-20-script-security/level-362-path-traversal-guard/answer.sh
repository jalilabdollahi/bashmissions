#!/usr/bin/env bash
# Print a file from public/, refusing names that could leave that folder.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi

name=$1

# Look at the *shape* of the name first. A ".." only climbs when it is a whole
# path component, so we match it alone, at the start, in the middle, or at the
# end. "summary..final.txt" matches none of these.
case $name in
  ""|/*|..|../*|*/../*|*/..)
    printf 'denied: %s\n' "$name" >&2
    exit 1
    ;;
esac

file="public/$name"
if [[ ! -f $file ]]; then
  printf 'not found: %s\n' "$name" >&2
  exit 1
fi
cat -- "$file"
