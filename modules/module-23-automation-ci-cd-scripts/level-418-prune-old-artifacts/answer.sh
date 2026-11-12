#!/usr/bin/env bash
set -euo pipefail

dir=${1:-} keep=${2:-}
if [[ -z $dir || ! $keep =~ ^[0-9]+$ ]]; then
  echo "usage: solution.sh DIR KEEP" >&2
  exit 2
fi
if [[ ! -d $dir ]]; then
  echo "no such directory: $dir" >&2
  exit 1
fi
keep=$(( 10#$keep ))
dir=${dir%/}

# A glob gives every name as one array element, spaces and all. Hidden files are
# not matched by "*", and the test skips directories and symlinks.
shopt -s nullglob
files=()
for path in "$dir"/*; do
  if [[ -f $path && ! -L $path ]]; then
    files+=("$path")
  fi
done

kept=0 removed=0
for path in "${files[@]+"${files[@]}"}"; do
  # rank = number of files that are newer than this one
  rank=0
  for other in "${files[@]}"; do
    [[ $other == "$path" ]] && continue
    if [[ $other -nt $path ]]; then
      rank=$(( rank + 1 ))
    elif [[ ! $path -nt $other && $other > $path ]]; then
      rank=$(( rank + 1 ))          # same mtime: the later name counts as newer
    fi
  done

  name=${path##*/}
  if (( rank < keep )); then
    echo "keep $name"
    kept=$(( kept + 1 ))
  else
    echo "remove $name"
    rm -f -- "$path"                # "--" protects names that begin with a dash
    removed=$(( removed + 1 ))
  fi
done

echo "kept $kept file(s), removed $removed file(s)"
