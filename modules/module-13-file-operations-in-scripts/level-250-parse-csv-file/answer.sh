#!/usr/bin/env bash
set -euo pipefail

first=1
while IFS=, read -r name role; do
  if (( first )); then
    first=0
    continue
  fi
  echo "$name=$role"
done < fixtures/data.txt
