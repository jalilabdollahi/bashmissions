#!/usr/bin/env bash
set -euo pipefail
customers=("$@")

# "${customers[@]}" in double quotes becomes one word per element, so spaces
# and a lone * are never split or globbed. printf reuses its format for
# each word, but with an empty array it still prints the format once,
# so the empty case is guarded explicitly.
if (( ${#customers[@]} > 0 )); then
  printf 'invoice: %s\n' "${customers[@]}"
fi
