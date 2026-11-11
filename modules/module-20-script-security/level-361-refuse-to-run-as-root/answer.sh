#!/usr/bin/env bash
# Log rotator that refuses to run with root's powers.
set -euo pipefail

uid=$(id -u)

# Guard first, action second. (( )) compares numbers, so "0" and "00" both count.
if (( uid == 0 )); then
  echo "refusing to run as root: use a normal account" >&2
  exit 1
fi

mv logs/app.log logs/app.log.1
: > logs/app.log
printf 'rotated as uid %d\n' "$uid"
