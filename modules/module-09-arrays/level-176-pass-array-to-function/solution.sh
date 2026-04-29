#!/usr/bin/env bash
set -euo pipefail

summarize() {
  local -n ref=$1
  echo "count=${#ref[@]}"
  echo "first=${ref[0]}"
}

items=(alpha beta gamma)
summarize items
