#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LOGFILE" >&2
  exit 2
fi

# -E switches grep to extended regex, so ( ) and | work without backslashes.
# The spaces around the group keep 4011, 1403 and /v429/ out.
# grep exits 1 when it finds nothing; "|| true" keeps that from failing the script.
grep -E ' (401|403|429) ' "$1" || true
