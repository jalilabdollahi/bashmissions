#!/usr/bin/env bash
set -euo pipefail

# read splits the line at the comma: first part -> name, the rest -> plan.
while IFS=, read -r name plan || [[ -n $name ]]; do
  # %-14.14s : minus = left-aligned, first 14 = minimum width (pad),
  #            .14 = maximum characters (truncate).
  # %8.8s    : right-aligned (no minus), padded to 8, cut at 8.
  printf '|%-14.14s|%8.8s|\n' "$name" "$plan"
done
