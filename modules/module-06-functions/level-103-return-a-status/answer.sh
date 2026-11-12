#!/usr/bin/env bash
# No "set -e" here on purpose: check_disk deliberately returns non-zero, and we
# want to look at that number ourselves instead of having the script abort.

check_disk() {
  local pct=$1
  if (( pct >= 95 )); then
    return 2
  elif (( pct >= 80 )); then
    return 1
  fi
  return 0
}

check_disk "$1"
code=$?        # must be read immediately: the next command overwrites $?

echo "disk $1% -> status $code"
exit "$code"
