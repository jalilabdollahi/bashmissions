#!/usr/bin/env bash
# Patch wave planner: OFFSET SIZE machine machine ...
# Print SIZE machines starting at index OFFSET, one per line.
# (Negative OFFSET counts from the end. Print nothing if the wave is empty.)
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh OFFSET SIZE [MACHINE...]" >&2
  exit 2
fi
offset=$1
size=$2
shift 2

machines=("$@")

# TODO: take a slice of machines and print it, one name per line
printf '%s\n' "${machines[@]}"
