#!/usr/bin/env bash
# Audit helper: list the *.conf files directly inside a directory,
# sorted, as an array. Print "found: N" and then the bare file names.
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1

# TODO: stop with "not a directory: <dir>" (stderr, exit 1) if it is not one

# TODO: fill an array from the OUTPUT OF A COMMAND:
#       find "$dir" -maxdepth 1 -name '*.conf' | sort
confs=()

# TODO: print found: N, then each file name without its directory
echo "found: ${#confs[@]}"
