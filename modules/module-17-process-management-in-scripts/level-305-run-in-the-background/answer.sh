#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh SERVER..." >&2
  exit 2
fi

for server in "$@"; do
  snapshot "$server" &
  # $! is only valid for the most recent background job, so save it at once.
  echo "$!" >> pids.txt
done

echo "started $# snapshots"
wait
