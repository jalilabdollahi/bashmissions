#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh CHECKS" >&2
  exit 2
fi
checks=$1

reindex &
pid=$!

for ((round = 1; round <= checks; round++)); do
  # kill -0 delivers nothing; it only reports whether the PID can be signalled.
  if ! kill -0 "$pid" 2>/dev/null; then
    echo "reindex finished"
    exit 0
  fi
  sleep 0.1
done

echo "reindex still running after $checks checks"
exit 1
