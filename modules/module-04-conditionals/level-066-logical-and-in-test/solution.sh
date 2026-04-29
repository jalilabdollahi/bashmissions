#!/usr/bin/env bash
set -euo pipefail

first="${1:-}"
second="${2:-}"

if [[ -n $first && -n $second ]]; then
  echo "complete"
else
  echo "incomplete"
fi
