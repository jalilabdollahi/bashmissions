#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh SITE_DIR..." >&2
  exit 2
fi

start=$PWD
built=0

for dir in "$@"; do
  # The cd happens in a child shell. When the parentheses close, that shell
  # (and its idea of "current folder") is gone; ours never moved.
  # As an if condition, a failure (even a failing cd) is just a "no".
  if ( cd "$dir" && sitebuild ); then
    echo "built $dir"
    built=$((built + 1))
  else
    echo "failed $dir"
  fi
done

echo "built $built of $# sites"
if [[ $PWD == "$start" ]]; then
  echo "still in the starting folder"
else
  echo "moved away from the starting folder"
fi

if (( built < $# )); then
  exit 1
fi
