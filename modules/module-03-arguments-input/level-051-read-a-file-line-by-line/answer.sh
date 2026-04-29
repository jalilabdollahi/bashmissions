#!/usr/bin/env bash
set -euo pipefail

line_number=1
while IFS= read -r line; do
  printf '%s: %s
' "$line_number" "$line"
  ((line_number += 1))
done < "$1"
