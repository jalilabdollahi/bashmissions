#!/usr/bin/env bash
set -euo pipefail

factorial() {
  local n=$1
  # Base case: without this the function would call itself forever.
  if (( n <= 1 )); then
    echo 1
    return
  fi
  # Recursive step: solve the smaller problem, then use its answer.
  local smaller
  smaller=$(factorial $(( n - 1 )))
  echo $(( n * smaller ))
}

if [[ ${1:-} =~ ^[0-9]+$ ]]; then
  factorial "$1"
else
  echo "usage: solution.sh N" >&2
  exit 1
fi
