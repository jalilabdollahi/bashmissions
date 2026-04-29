#!/usr/bin/env bash
set -euo pipefail

exec 9> job.lock
if flock -n 9; then
  echo "locked" > protected.txt
  echo "lock=acquired"
  cat protected.txt
fi
