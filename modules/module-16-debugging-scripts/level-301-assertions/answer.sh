#!/usr/bin/env bash
set -euo pipefail

assert_eq() {
  local expected=$1 actual=$2 label=$3
  # The quotes around "$expected" make == a literal comparison: without them
  # the right side would be a glob pattern.
  if [[ $actual == "$expected" ]]; then
    echo "PASS: $label"
    return 0
  fi
  echo "FAIL: $label: expected '$expected' but got '$actual'" >&2
  return 1
}

# Last command: its status (0 or 1) is the script's status.
assert_eq "$1" "$2" "$3"
