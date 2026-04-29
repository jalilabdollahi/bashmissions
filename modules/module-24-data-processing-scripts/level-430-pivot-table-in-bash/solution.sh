#!/usr/bin/env bash
set -euo pipefail
declare -A sum
while IFS=, read -r region value; do
  [[ $region == region ]] && continue
  sum[$region]=$(( ${sum[$region]:-0} + value ))
done < fixtures/data.csv
for key in "${!sum[@]}"; do echo "$key=${sum[$key]}"; done | sort
