#!/usr/bin/env bash
set -euo pipefail

first=$(mktemp)
second=$(mktemp)
trap 'rm -f "$first" "$second"' EXIT

touch -t 202001010000 "$first"
touch -t 202001010001 "$second"

if [ "$second" -nt "$first" ]; then
  echo "second newer"
fi
