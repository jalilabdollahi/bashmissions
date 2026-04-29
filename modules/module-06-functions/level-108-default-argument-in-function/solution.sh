#!/usr/bin/env bash
set -euo pipefail

greet() {
  local name="${1:-guest}"
  echo "Hello, $name"
}

greet "${1:-}"
