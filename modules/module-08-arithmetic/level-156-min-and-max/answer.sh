#!/usr/bin/env bash
set -euo pipefail

min="$1"
max="$1"
shift

for n in "$@"; do
  if (( n < min )); then
    min="$n"
  fi
  if (( n > max )); then
    max="$n"
  fi
done

printf 'min=%s max=%s\n' "$min" "$max"
