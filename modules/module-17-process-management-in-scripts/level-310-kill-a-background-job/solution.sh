#!/usr/bin/env bash
set -euo pipefail

sleep 5 &
pid=$!
kill "$pid"
wait "$pid" 2>/dev/null || true
if ! kill -0 "$pid" 2>/dev/null; then
  echo "stopped=yes"
fi
