#!/usr/bin/env bash
# The right number depends on the player's layout, so compare it with the real
# contents of solution.sh: that line must hold the echo with the message.
[[ -s $BM_STDERR_FILE ]] || exit 0
n=$(sed -E -n 's/^error \(line ([0-9]+)\):.*/\1/p' "$BM_STDERR_FILE" | head -n 1)
text=$(sed -E -n 's/^error \(line [0-9]+\): //p' "$BM_STDERR_FILE" | head -n 1)
kind=${text%%:*}
src=$(sed -n "${n}p" solution.sh)
if [[ $src != *echo* || $src != *"$kind"* ]]; then
  echo "You reported line $n, but that line of solution.sh is: $src"
  echo "It should be the line holding the echo that says: $kind"
  exit 1
fi
exit 0
