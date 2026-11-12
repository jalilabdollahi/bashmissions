#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh PREFIX" >&2
  exit 2
fi

prefix=$1
# {08..12} starts with a zero, so Bash pads every number to two digits.
for n in {08..12}; do
  echo "$prefix-$n"
done
