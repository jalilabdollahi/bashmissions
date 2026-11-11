#!/usr/bin/env bash
set -euo pipefail

servers=("$@")
pids=()

# Start phase: nothing is waited for yet, so all backups run together.
for server in "${servers[@]}"; do
  vmbackup "$server" &
  pids+=("$!")
done

# Collect phase: waiting in start order gives results in start order, no
# matter which job actually finished first.
statuses=()
for pid in "${pids[@]}"; do
  status=0
  wait "$pid" || status=$?
  statuses+=("$status")
done

ok=0
failed=0
for i in "${!servers[@]}"; do
  if [[ ${statuses[i]} -eq 0 ]]; then
    echo "${servers[i]} ok"
    ok=$((ok + 1))
  else
    echo "${servers[i]} failed (${statuses[i]})"
    failed=$((failed + 1))
  fi
done

echo "$ok ok, $failed failed"
if [[ $failed -gt 0 ]]; then
  exit 1
fi
