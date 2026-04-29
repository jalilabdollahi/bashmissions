#!/usr/bin/env bash
set -euo pipefail

sleep 0.1 &
pid=$!
if [[ $pid =~ ^[0-9]+$ ]]; then
  echo "pid=captured"
fi
wait "$pid"
