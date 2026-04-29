#!/usr/bin/env bash
set -euo pipefail

names=("alpha" "two words" "gamma")
for name in "${names[@]}"; do
  printf '[%s]\n' "$name"
done
