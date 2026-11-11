#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh NAME [ENTRY...]" >&2
  exit 2
fi
name=$1
shift
allowed=("$@")

for entry in "${allowed[@]}"; do
  # Quoting the right-hand side makes == an exact, literal comparison.
  # Unquoted, it would be a glob pattern ("*" would match anything).
  if [[ $entry == "$name" ]]; then
    echo "$name: allowed"
    exit 0
  fi
done

echo "$name: denied"
exit 1
