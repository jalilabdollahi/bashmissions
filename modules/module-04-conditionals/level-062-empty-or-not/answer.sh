#!/usr/bin/env bash
set -euo pipefail

# ${N:-} keeps set -u quiet when an argument was not supplied.
name="${1:-}"
note="${2:-}"

if [[ -z $name ]]; then
  echo "error: customer name required" >&2
  exit 2
fi

echo "ticket for: $name"

if [[ -n $note ]]; then
  echo "note: $note"
fi
