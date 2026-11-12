#!/usr/bin/env bash
# The reported line must be the line of solution.sh holding the failing command.
[[ -s $BM_STDERR_FILE ]] || exit 0
n=$(sed -E -n 's/.* at line ([0-9]+)$/\1/p' "$BM_STDERR_FILE" | head -n 1)
cmd=$(sed -E -n 's/^failed: (.*) \(status [0-9]+\) at line [0-9]+$/\1/p' "$BM_STDERR_FILE" | head -n 1)
src=$(sed -n "${n}p" solution.sh)
if [[ $src != *"$cmd"* ]]; then
  echo "You reported line $n, but that line of solution.sh is: $src"
  echo "It should be the line of: $cmd"
  exit 1
fi
if (( $(grep -c . "$BM_STDERR_FILE") != 1 )); then
  echo "Expected exactly one line on stderr."
  exit 1
fi
exit 0
