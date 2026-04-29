#!/usr/bin/env bash
set -euo pipefail

needle=${1:-}
items=(alpha beta gamma)
result=missing
for item in "${items[@]}"; do
  if printf '%s\n' "$item" | grep -qx -- "$needle"; then
    result=found
    break
  fi
done
echo "$result"
