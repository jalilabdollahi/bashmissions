#!/usr/bin/env bash
# Parse the load averages out of uptime and judge them.
set -euo pipefail

limit=${1:-}
if [[ ! $limit =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
  echo "usage: solution.sh LIMIT" >&2
  exit 2
fi

out=$(uptime)
if [[ $out != *"load average: "* ]]; then
  echo "cannot parse uptime" >&2
  exit 3
fi

tail_part=${out##*load average: }               # "0.52, 0.58, 0.59"
IFS=', ' read -r l1 l5 l15 <<< "$tail_part"     # commas and spaces both separate

echo "load 1m=$l1 5m=$l5 15m=$l15"

# Bash arithmetic is integer only, so awk compares the decimals.
# awk exits 0 when the first number is larger than the second.
bigger() { awk -v a="$1" -v b="$2" 'BEGIN { exit !(a + 0 > b + 0) }'; }

status=0
if bigger "$l1" "$limit"; then
  echo "HIGH: 1m load $l1 is above $limit"
  status=1
else
  echo "OK"
fi

if bigger "$l1" "$l15"; then
  echo "trend: rising"
elif bigger "$l15" "$l1"; then
  echo "trend: falling"
fi

exit "$status"
