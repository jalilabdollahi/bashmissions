#!/usr/bin/env bash
set -euo pipefail

if diff <(printf '%s\n' a b) <(printf '%s\n' a b) >/dev/null; then
  echo "diff=match"
fi
