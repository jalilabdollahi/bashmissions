#!/usr/bin/env bash
set -euo pipefail

logfile="$1"

# grep -q prints nothing; it only reports "found" (exit 0) or "not found" (exit 1).
# Inside an if, a non-zero status does not trip set -e, it just picks the else branch.
if grep -q 'ERROR' "$logfile"; then
  echo "needs attention: ERROR found in $logfile"
else
  echo "clean: no ERROR in $logfile"
fi
