#!/usr/bin/env bash
set -euo pipefail

APP_NAME="bashmissions"

format_name() {
  printf '%s:%s\n' "$APP_NAME" "$1"
}

main() {
  format_name "module-layout"
}

main "$@"
