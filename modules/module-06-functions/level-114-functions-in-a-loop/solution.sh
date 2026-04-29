#!/usr/bin/env bash
set -euo pipefail

print_step() {
  echo "step=$1"
}

for step in build test deploy; do
  print_step "$step"
done
