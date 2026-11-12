#!/usr/bin/env bash
# Retire old reports: move every file given on the command line into archive/
# as NAME.old. This version checks and moves one file at a time, so a bad name
# in the middle leaves a half-archived mess. Restructure it: first check
# everything, then (and only then) move anything.

if (( $# == 0 )); then
  echo "usage: solution.sh FILE..." >&2
  exit 2
fi

mkdir -p archive
count=0
for f in "$@"; do
  if [[ ! -f $f ]]; then
    echo "missing: $f" >&2
    exit 1
  fi
  mv "$f" "archive/$f.old"
  count=$(( count + 1 ))
done
echo "archived $count files"
