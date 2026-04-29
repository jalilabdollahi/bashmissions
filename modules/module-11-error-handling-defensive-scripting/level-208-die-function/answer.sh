#!/usr/bin/env bash
set -u

die() {
  echo "error: $*"
  exit 2
}

if [[ ${1:-} != ok ]]; then
  die "expected ok"
fi
echo "status=ok"
