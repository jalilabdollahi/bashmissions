#!/usr/bin/env bash
set -euo pipefail
mode=${1:-}
if [[ $mode != alpha && $mode != num ]]; then
  echo "usage: solution.sh alpha|num ITEM..." >&2
  exit 2
fi
shift
items=("$@")

# An empty array through printf would still emit one blank line, and that
# blank line would become a bogus element. Stop early instead.
if (( ${#items[@]} == 0 )); then
  exit 0
fi

# The round trip: array -> lines -> sort -> array.
if [[ $mode == num ]]; then
  mapfile -t sorted < <(printf '%s\n' "${items[@]}" | sort -n)
else
  mapfile -t sorted < <(printf '%s\n' "${items[@]}" | sort)
fi

printf '%s\n' "${sorted[@]}"
