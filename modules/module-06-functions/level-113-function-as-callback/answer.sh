#!/usr/bin/env bash
set -euo pipefail

uppercase() {
  echo "${1^^}"
}

run_callback() {
  local callback="$1"
  local value="$2"
  "$callback" "$value"
}

run_callback uppercase hello
