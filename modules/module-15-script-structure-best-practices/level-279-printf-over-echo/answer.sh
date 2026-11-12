#!/usr/bin/env bash
# Shelf-tag printer: every argument on its own line, exactly as typed.
set -euo pipefail

for tag in "$@"; do
  # The format is a constant, the data is an argument. printf never reads
  # options from its data and never interprets % or \ inside it.
  printf '%s\n' "$tag"
done
printf 'count: %d\n' "$#"
