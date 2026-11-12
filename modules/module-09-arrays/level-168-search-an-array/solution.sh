#!/usr/bin/env bash
# Allow-list guard: NAME first, then the allowed entries.
# Print "<name>: allowed" (exit 0) when NAME equals one entry exactly,
# otherwise "<name>: denied" (exit 1).
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh NAME [ENTRY...]" >&2
  exit 2
fi
name=$1
shift
allowed=("$@")

# TODO: look at every entry; an exact match means allowed
echo "$name: denied"
exit 1
