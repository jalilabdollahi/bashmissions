#!/usr/bin/env bash
# Restart-request handler with an allow-list.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SERVICE" >&2
  exit 2
fi

service=$1
allowed=fixtures/allowed-services.txt

# -F fixed text (no regex), -x whole line (no prefixes), -q only the exit status.
# "--" ends options so a value like -v is searched for, not obeyed.
if ! grep -Fxq -- "$service" "$allowed"; then
  printf 'denied: %s\n' "$service" >&2
  exit 1
fi

printf '%s\n' "$service" >> queue.txt
printf 'queued: %s\n' "$service"
