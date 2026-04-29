#!/usr/bin/env bash
set -euo pipefail

main() {
  printf 'argc=%s\n' "$#"
  printf 'first=%s\n' "${1:-none}"
}

main "$@"
