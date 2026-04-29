#!/usr/bin/env bash
set -euo pipefail

factorial() {
  local n="$1"
  if [ "$n" -le 1 ]; then
    echo 1
    return
  fi
  local previous
  previous=$(factorial $((n - 1)))
  echo $((n * previous))
}

result=$(factorial 5)
echo "factorial(5)=$result"
