#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1

if [[ ! -d $dir ]]; then
  echo "not a folder: $dir" >&2
  exit 1
fi

# The only byte that cannot appear in a file name is NUL, so it is the one
# safe separator. -print0 writes it, xargs -0 splits on it and on nothing else.
find "$dir" -type f -name '*.log' -print0 | xargs -0 cksum | sort
