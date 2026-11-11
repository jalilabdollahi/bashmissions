#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh CUSTOMER_ID..." >&2
  exit 2
fi

sent=0
remaining=$#

for id in "$@"; do
  # "|| ..." keeps a 404 from ending the script; the request still counts.
  if body=$(curl -sS --fail "https://billing.lanternfish.example/api/v1/customers/$id/usage" 2>/dev/null); then
    echo "$id: $body"
  else
    echo "$id: unavailable"
  fi

  sent=$((sent + 1))
  remaining=$((remaining - 1))

  # Every second request, rest for a second: that is two requests per second.
  # Sleeping when nothing is left would only make the script slower.
  if (( sent % 2 == 0 && remaining > 0 )); then
    sleep 1
  fi
done
