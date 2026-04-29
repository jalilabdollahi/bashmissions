#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r line; do
  echo "cmd=$line"
done < <(printf '%s
' build test deploy)
