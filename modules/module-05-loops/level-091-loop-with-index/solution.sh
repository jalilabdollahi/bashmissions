#!/usr/bin/env bash
set -euo pipefail

colors=(red green blue)
for ((i = 0; i < ${#colors[@]}; i++)); do
  echo "$i:${colors[$i]}"
done
