#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SRC" >&2
  exit 2
fi
src=$1

# A FIFO is a file that is really a pipe: whatever one process writes into
# it, another process can read out, with nothing stored on disk.
mkfifo feed.pipe

# The writer must run in the background. Opening a FIFO blocks until the
# other end is open too, so doing both in one foreground process would hang.
tailfeed "$src" feed.pipe &
pid=$!

errors=0
# Redirecting the loop (not piping into it) keeps "errors" in this shell.
while IFS= read -r line; do
  if [[ $line == *ERROR* ]]; then
    echo "!! $line"
    errors=$((errors + 1))
  fi
done < feed.pipe

echo "errors=$errors"

status=0
wait "$pid" 2>/dev/null || status=$?
rm feed.pipe
exit "$status"
