#!/usr/bin/env bash
set -euo pipefail

mapfile -t steps < "$1"
n=${#steps[@]}

# A rehearsal's chatter is not our business; only its status matters.
# Used as an if condition, a failure is an answer and does not trip set -e.
if try-steps "$n" > /dev/null 2>&1; then
  echo "all $n steps pass"
  exit 0
fi

# Invariant: the first failing step is somewhere in lo..hi (1-based positions).
lo=1
hi=$n
while (( lo < hi )); do
  mid=$(( (lo + hi) / 2 ))
  if try-steps "$mid" > /dev/null 2>&1; then
    lo=$(( mid + 1 ))       # first mid steps are fine: culprit is later
  else
    hi=$mid                 # culprit is within the first mid steps
  fi
done

echo "first failing step: $lo ${steps[lo - 1]}"   # position 1 is index 0
