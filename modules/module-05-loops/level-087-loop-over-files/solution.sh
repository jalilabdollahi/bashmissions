#!/usr/bin/env bash
set -euo pipefail

for file in fixtures/*.txt; do
  basename "$file"
done
