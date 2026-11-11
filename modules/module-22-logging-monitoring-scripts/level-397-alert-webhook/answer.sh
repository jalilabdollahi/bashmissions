#!/usr/bin/env bash
# Send an alert to a webhook and report honestly whether it was delivered.
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh HOST SEVERITY MESSAGE" >&2
  exit 2
fi
host=$1
severity=$2
message=$3

if [[ -z ${WEBHOOK_URL:-} ]]; then
  echo "WEBHOOK_URL is not set" >&2
  exit 2
fi
case $severity in
  info|warning|critical) ;;
  *) echo "bad severity: $severity" >&2; exit 2 ;;
esac

# Escape backslashes first, then quotes; the other order would double-escape.
message=${message//\\/\\\\}
message=${message//\"/\\\"}
body="{\"host\":\"$host\",\"severity\":\"$severity\",\"text\":\"$message\"}"

# -sS: no progress meter but still show errors; -o /dev/null: drop the reply body;
# -w: print just the status code. When curl cannot connect it fails and prints
# 000, so "|| true" lets us report it ourselves instead of dying under set -e.
status=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 5 \
  -X POST -H 'Content-Type: application/json' -d "$body" "$WEBHOOK_URL") || true

if [[ $status == 2?? ]]; then
  echo "alert sent ($status)"
else
  echo "alert failed (${status:-000})" >&2
  exit 1
fi
