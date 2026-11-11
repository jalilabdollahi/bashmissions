#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh WORKERS" >&2
  exit 2
fi
workers=$1

# -n 1: one image per thumb call.  -P: up to $workers calls at once.
# xargs reads the names from our own stdin.
# With pipefail the pipeline fails if xargs fails (status 123), and the
# "if !" keeps set -e out of the way so the sorted lines are always printed.
if ! xargs -n 1 -P "$workers" thumb | sort; then
  exit 1
fi
