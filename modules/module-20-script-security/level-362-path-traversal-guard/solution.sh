#!/usr/bin/env bash
# "fetch" for the dental portal: print public/NAME. Right now NAME may climb
# out of public with .. components or start at the root of the disk.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi

name=$1
# TODO: before reading anything, refuse names that are empty, start with /,
# or have a ".." path component. Keep "summary..final.txt" legal.
if [[ ! -f public/$name ]]; then
  echo "not found: $name" >&2
  exit 1
fi
cat "public/$name"
