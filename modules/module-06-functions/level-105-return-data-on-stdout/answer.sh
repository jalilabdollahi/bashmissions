#!/usr/bin/env bash
set -euo pipefail

# Functions "return" data by printing it. Whoever calls the function decides
# whether it goes to the screen or into a variable.
domain_for() {
  local slug
  slug=$(printf '%s' "$1" | tr 'A-Z ' 'a-z-' | tr -cd 'a-z0-9-')
  printf '%s.lanternfish.example\n' "$slug"
}

for name in "$@"; do
  address=$(domain_for "$name")     # $( ) collects everything the function printed
  echo "$name -> $address"
done
