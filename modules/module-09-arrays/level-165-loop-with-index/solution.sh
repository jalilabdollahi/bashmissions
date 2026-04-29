#!/usr/bin/env bash
set -euo pipefail

colors=(red green blue)
for i in "${!colors[@]}"; do
  echo "$i:${colors[$i]}"
done
