#!/usr/bin/env bash
set -euo pipefail

index=1
for arg in "$@"; do
  printf '%s: %s
' "$index" "$arg"
  ((index += 1))
done
