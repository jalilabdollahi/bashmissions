#!/usr/bin/env bash
set -euo pipefail

report_error() {
  local line=$1
  local message=$2
  printf 'line=%s message=%s\n' "$line" "$message"
}

report_error "$LINENO" "missing input"
