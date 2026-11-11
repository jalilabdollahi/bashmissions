#!/usr/bin/env bash
# Job wrapper that shows output live and keeps a permanent record.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh LOGFILE JOB" >&2
  exit 2
fi
log=$1
job=$2

# tee would only fail halfway through; check the folder before reading anything.
if [[ ! -d $(dirname "$log") ]]; then
  echo "cannot write to $log" >&2
  exit 1
fi

count=0
while IFS= read -r line; do
  count=$((count + 1))
  printf '%s: %s\n' "$job" "$line" | tee -a "$log"   # -a appends, never truncates
done
printf '%s: finished, %d lines\n' "$job" "$count" | tee -a "$log"
