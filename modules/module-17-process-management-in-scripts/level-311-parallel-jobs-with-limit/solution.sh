#!/usr/bin/env bash
set -euo pipefail

running=0
for item in a b c; do
  { echo "$item" > "$item.out"; } &
  ((++running))
  if (( running == 2 )); then
    wait -n
    ((--running))
  fi
done
wait
cat ./*.out | sort
