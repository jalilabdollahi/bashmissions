#!/usr/bin/env bash
set -euo pipefail

file=${1:-}
if [[ ! -r $file ]]; then
  echo "file=invalid"
  exit 1
fi
echo "lines=$(wc -l < "$file")"
