#!/usr/bin/env bash
set -euo pipefail

make_values() {
  printf '%s\n' alpha beta gamma
}

mapfile -t values < <(make_values)
joined=$(IFS=,; echo "${values[*]}")
echo "values=$joined"
