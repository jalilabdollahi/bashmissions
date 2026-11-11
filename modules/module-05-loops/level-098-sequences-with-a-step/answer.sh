#!/usr/bin/env bash
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh COUNT STEP" >&2
  exit 2
fi

count=$1
step=$2
n=0

# No servers, no schedule. Asking seq to count up to a negative last value
# would be an error on some systems, so stop early.
if (( count < 1 )); then
  exit 0
fi

# Offsets are 0, step, 2*step ... up to (count-1)*step.
for offset in $(seq 0 "$step" $(( (count - 1) * step ))); do
  n=$(( n + 1 ))
  minutes=$(( 120 + offset ))      # 02:00 is minute 120 of the day
  printf 'host-%d starts at %02d:%02d\n' "$n" $(( minutes / 60 )) $(( minutes % 60 ))
done
