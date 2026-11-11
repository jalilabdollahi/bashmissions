#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SLOTS NAME..." >&2
  exit 2
fi
slots=$1
shift

# The semaphore: a FIFO that holds one token (a newline) per free seat.
mkfifo slots.fifo
# <> opens it for reading AND writing, so the open does not wait for a partner.
exec 3<> slots.fifo
# Once it is open the name is not needed any more; the descriptor stays valid.
rm slots.fifo

for ((i = 0; i < slots; i++)); do
  echo >&3
done

: > failed.log

for name in "$@"; do
  # P(): take a token. With none left, read blocks until a job returns one.
  read -r -u 3
  {
    if ! render "$name"; then
      echo "$name" >> failed.log
    fi
    # V(): always give the token back, success or failure.
    echo >&3
  } &
done
wait

failed=$(( $(wc -l < failed.log) ))
echo "rendered $#, failed $failed"
if (( failed > 0 )); then
  exit 1
fi
