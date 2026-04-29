#!/usr/bin/env bash
set -euo pipefail

for row in A B; do
  for col in 1 2; do
    echo "$row$col"
  done
done
