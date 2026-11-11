#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh WEEKS" >&2
  exit 2
fi

weeks=$1
week=1
size=100

# The test is checked before every round, so weeks=0 never enters the body.
while (( week <= weeks )); do
  size=$(( size + 25 ))
  echo "week $week: $size GB"
  # Forgetting this line would make the loop run forever.
  week=$(( week + 1 ))
done
