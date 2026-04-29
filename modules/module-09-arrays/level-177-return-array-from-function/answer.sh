#!/usr/bin/env bash
set -euo pipefail

make_items() {
  printf '%s\n' alpha beta gamma
}

mapfile -t items < <(make_items)
echo "items=${items[*]}"
