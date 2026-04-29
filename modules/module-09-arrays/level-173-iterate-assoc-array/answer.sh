#!/usr/bin/env bash
set -euo pipefail

declare -A ports=([web]=80 [ssh]=22 [dns]=53)
mapfile -t keys < <(printf '%s\n' "${!ports[@]}" | sort)
for key in "${keys[@]}"; do
  echo "$key=${ports[$key]}"
done
