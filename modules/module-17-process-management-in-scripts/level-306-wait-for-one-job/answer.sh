#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SERVER" >&2
  exit 2
fi
server=$1

integrity-check "$server" &
pid=$!

echo "checking $server"

# Under set -e a failing wait would end the script right here, before we
# could report anything. "|| status=$?" turns the failure into data.
status=0
wait "$pid" || status=$?

echo "$server: status $status"
exit "$status"
