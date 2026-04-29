#!/usr/bin/env bash
set -euo pipefail

sleep 0.3 &
pid=$!
if kill -0 "$pid" 2>/dev/null; then
  echo "running=yes"
fi
kill "$pid" 2>/dev/null || true
wait "$pid" 2>/dev/null || true
