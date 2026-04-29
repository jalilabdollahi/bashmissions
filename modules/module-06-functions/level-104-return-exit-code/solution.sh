#!/usr/bin/env bash
set -euo pipefail

check_ok() {
  if [ "${1:-}" = "ok" ]; then
    return 0
  fi
  return 1
}

if check_ok "${1:-}"; then
  echo "success"
else
  echo "failure"
fi
