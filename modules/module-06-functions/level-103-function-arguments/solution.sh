#!/usr/bin/env bash
set -euo pipefail

show_pair() {
  printf '%s -> %s
' "$1" "$2"
}

show_pair "$1" "$2"
