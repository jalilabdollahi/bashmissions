#!/usr/bin/env bash
# The backups must overlap: no job may end before every job has started.
[[ -f .calls.log ]] || exit 0
last_start=$(grep -n '^start ' .calls.log | tail -n 1 | cut -d: -f1)
first_end=$(grep -n '^end ' .calls.log | head -n 1 | cut -d: -f1)
if [[ -n $last_start && -n $first_end ]] && (( first_end < last_start )); then
  echo "A backup finished before the last one started: start them all first, wait afterwards."
  exit 1
fi
exit 0
