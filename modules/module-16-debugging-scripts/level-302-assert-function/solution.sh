#!/usr/bin/env bash
set -euo pipefail

assert_eq() {
  local expected=$1
  local actual=$2
  if [[ $expected != "$actual" ]]; then
    printf 'not ok: expected %s got %s\n' "$expected" "$actual"
    exit 1
  fi
  printf 'ok: %s\n' "$actual"
}
assert_eq "42" "$((40 + 2))"
