#!/usr/bin/env bash
if [[ $# -lt 3 ]]; then
  echo "usage: solution.sh BASE ATTEMPTS CAP" >&2
  exit 2
fi

base=$1
attempts=$2
cap=$3

delay=$base
total=0

for (( k = 1; k <= attempts; k++ )); do
  # The delay for this attempt may already be too big (e.g. base above cap).
  if (( delay > cap )); then
    delay=$cap
  fi
  echo "attempt $k: wait ${delay}s"
  total=$(( total + delay ))
  # Prepare the next attempt's delay.
  delay=$(( delay * 2 ))
done

echo "total wait: ${total}s"
