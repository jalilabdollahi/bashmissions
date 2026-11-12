#!/usr/bin/env bash
# Weekly sweep for files that anybody can rewrite. Ollie's version greps the
# output of ls -l; it breaks on spaces and misreads modes like 602.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi

dir=$1
# TODO: check that DIR is a folder, then let find test the permission bit
# itself, sort the paths, and print the "world-writable: N" summary.
ls -lR "$dir" | grep 'rw-rw-rw-'
