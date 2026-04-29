#!/usr/bin/env bash
set -euo pipefail

require_value() {
  if [ -z "${1:-}" ]; then
    return 1
  fi
  echo "valid=$1"
}

require_value "${1:-}"
