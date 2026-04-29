#!/usr/bin/env bash
set -euo pipefail

steps=(build test deploy)
for step in "${steps[@]}"; do
  echo "step=$step"
done
