#!/usr/bin/env bash
set -euo pipefail

die() {
  echo "error: $1" >&2
  exit 1
}

if [ -z "${1:-}" ]; then
  die "missing value"
fi

echo "value=$1"
