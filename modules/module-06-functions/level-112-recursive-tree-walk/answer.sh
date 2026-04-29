#!/usr/bin/env bash
set -euo pipefail

walk() {
  local dir="$1"
  local base="$2"
  local item rel
  for item in "$dir"/*; do
    [ -e "$item" ] || continue
    rel="${item#$base/}"
    if [ -d "$item" ]; then
      walk "$item" "$base"
    else
      echo "$rel"
    fi
  done
}

walk fixtures/tree fixtures/tree
