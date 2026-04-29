#!/usr/bin/env bash
set -euo pipefail

fifo=messages.fifo
mkfifo "$fifo"
{ echo "from fifo" > "$fifo"; } &
read -r line < "$fifo"
wait
echo "line=$line"
rm -f "$fifo"
