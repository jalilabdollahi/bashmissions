#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r line; do
  if [ "$line" = "STOP" ]; then
    exit 0
  fi
  echo "$line"
done < "$1"
