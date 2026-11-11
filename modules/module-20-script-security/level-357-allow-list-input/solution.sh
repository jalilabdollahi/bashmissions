#!/usr/bin/env bash
# Ollie's restart-request handler. It rejects a few "bad" characters and
# accepts the rest. Flip it: accept only names found in the allow-list file.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SERVICE" >&2
  exit 2
fi

service=$1
if [[ $service == *";"* || $service == *"&"* ]]; then
  echo "denied: $service" >&2
  exit 1
fi
# TODO: replace the block-list above with a lookup in
# fixtures/allowed-services.txt that matches the WHOLE line, as fixed text.
echo "$service" >> queue.txt
echo "queued: $service"
