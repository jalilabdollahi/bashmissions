#!/usr/bin/env bash
set -euo pipefail

path="$1"

# Order matters: -e is true for files AND directories, so the specific tests
# (-f, -d) must come first and -e catches whatever else exists.
if [[ -f $path ]]; then
  echo "$path: regular file"
elif [[ -d $path ]]; then
  echo "$path: directory"
elif [[ -e $path ]]; then
  echo "$path: something else"
else
  echo "$path: not found"
fi
