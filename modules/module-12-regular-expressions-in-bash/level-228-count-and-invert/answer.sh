#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LOGFILE" >&2
  exit 2
fi
log=$1

# -v inverts the match: everything that is NOT a comment (^#) or empty (^$).
# -c prints how many lines were selected. When it selects none it prints 0 but exits 1,
# so "|| true" saves set -e; the 0 is still printed by grep itself.
entries=$(grep -v -E '^(#|$)' "$log" | grep -c '' || true)

# The failure count must come from real entries only, so we filter comments first.
failed=$(grep -v -E '^(#|$)' "$log" | grep -c 'Failed password' || true)

echo "entries: $entries"
echo "failed: $failed"
