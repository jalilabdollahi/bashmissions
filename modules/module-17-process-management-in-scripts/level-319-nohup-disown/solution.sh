#!/usr/bin/env bash
set -euo pipefail

nohup bash -c 'echo detached > detached.txt' >/dev/null 2>&1 &
pid=$!
disown "$pid" 2>/dev/null || true
for _ in {1..20}; do
  [[ -f detached.txt ]] && break
  sleep 0.05
done
cat detached.txt
