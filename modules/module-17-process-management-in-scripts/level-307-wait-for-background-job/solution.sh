#!/usr/bin/env bash
set -euo pipefail

( sleep 0.05; exit 0 ) &
pid=$!
wait "$pid"
echo "wait_status=$?"
