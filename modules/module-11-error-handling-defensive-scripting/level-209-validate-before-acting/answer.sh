#!/usr/bin/env bash
set -euo pipefail

if (( $# == 0 )); then
  echo "usage: solution.sh FILE..." >&2
  exit 2
fi

# Phase 1: look at everything, change nothing. Report every problem at once.
bad=0
for f in "$@"; do
  if [[ ! -f $f ]]; then
    echo "missing: $f" >&2
    bad=$(( bad + 1 ))
  fi
done
if (( bad > 0 )); then
  exit 1
fi

# Phase 2: every input is known good, so now it is safe to act.
mkdir -p archive
for f in "$@"; do
  mv -- "$f" "archive/$f.old"
done
echo "archived $# files"
