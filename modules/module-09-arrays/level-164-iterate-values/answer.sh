#!/usr/bin/env bash
set -euo pipefail
amounts=("$@")

total=0
large=0
for amount in "${amounts[@]}"; do      # amount takes each VALUE in turn
  total=$(( total + amount ))
  if (( amount >= 100 )); then
    large=$(( large + 1 ))
  fi
done

echo "total: $total"
echo "large: $large"
