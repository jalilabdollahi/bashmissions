#!/usr/bin/env bash
# Load a host list (one entry per line) into an array with mapfile,
# then report: loaded: N / first: ... / last: ...
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh FILE" >&2
  exit 2
fi
file=$1

# TODO: complain "no such file: <path>" (stderr, exit 1) if it is unreadable

# TODO: read every line of the file into an array called hosts
hosts=($(cat "$file"))

# TODO: print loaded / first / last ("(none)" when the file is empty)
echo "loaded: ${#hosts[@]}"
