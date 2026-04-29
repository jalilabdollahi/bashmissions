#!/usr/bin/env bash
set -euo pipefail

for n in {1..5}; do
  if [ "$n" -eq 3 ]; then
    continue
  fi
  echo "$n"
done
