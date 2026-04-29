#!/usr/bin/env bash
set -euo pipefail

wait_time=1
for attempt in 1 2 3; do
  echo "attempt=$attempt wait=$wait_time"
  ((wait_time *= 2))
done
