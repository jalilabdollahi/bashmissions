#!/usr/bin/env bash
set -euo pipefail

summarize_array() {
  local -n items_ref="$1"
  local last_index=$((${#items_ref[@]} - 1))
  printf 'count=%s first=%s last=%s\n' "${#items_ref[@]}" "${items_ref[0]}" "${items_ref[$last_index]}"
}

colors=(red green blue)
summarize_array colors
