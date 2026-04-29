#!/usr/bin/env bash
set -euo pipefail

print_status() {
  local service=$1
  local state=$2
  printf '%s=%s\n' "$service" "$state"
}
print_status api ok
print_status worker ok
