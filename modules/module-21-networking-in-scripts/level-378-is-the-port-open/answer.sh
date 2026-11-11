#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh HOST PORT..." >&2
  exit 2
fi
host=$1
shift

closed=0
for port in "$@"; do
  # -z: only connect, send nothing.  -w 2: give up after two seconds.
  # nc's exit status is the answer; "if" keeps set -e from stopping on a closed port.
  if nc -z -w 2 "$host" "$port"; then
    echo "$host:$port open"
  else
    echo "$host:$port closed"
    closed=$((closed + 1))
  fi
done

if (( closed > 0 )); then
  exit 1
fi
