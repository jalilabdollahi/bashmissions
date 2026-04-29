#!/usr/bin/env bash
set -euo pipefail

target="scratch.tmp"
echo "temporary" > "$target"
if [[ -f $target && $target == *.tmp ]]; then
  rm -- "$target"
fi
echo "deleted=$([[ ! -e $target ]] && echo yes || echo no)"
