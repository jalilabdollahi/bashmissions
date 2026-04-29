#!/usr/bin/env bash
set -euo pipefail

fifo=sem.fifo
mkfifo "$fifo"
exec 3<>"$fifo"
rm -f "$fifo"
printf '.%.0s' {1..2} >&3
for item in a b c; do
  read -r -n1 _ <&3
  { echo "$item" > "$item.out"; printf . >&3; } &
done
wait
exec 3>&-
cat ./*.out | sort
