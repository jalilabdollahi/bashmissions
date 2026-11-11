#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh GRACE" >&2
  exit 2
fi
grace=$1

soaktest &
pid=$!

sleep "$grace"

# kill succeeds only if the process was still there to receive SIGTERM.
# Without the if, a failing kill would end this script under set -e.
if kill "$pid" 2>/dev/null; then
  status=0
  wait "$pid" 2>/dev/null || status=$?
  echo "soaktest stopped (status $status)"
else
  status=0
  wait "$pid" 2>/dev/null || status=$?
  echo "soaktest finished by itself (status $status)"
fi
