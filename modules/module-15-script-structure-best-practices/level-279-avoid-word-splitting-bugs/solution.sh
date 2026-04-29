#!/usr/bin/env bash
set -euo pipefail

for arg in "$@"; do
  printf '<%s>\n' "$arg"
done
