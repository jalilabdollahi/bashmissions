#!/usr/bin/env bash
# Random output cannot be compared literally. Check what must hold instead:
# the line count, the range, the end points, and that the seed replays.
seed="$1"; low="$2"; high="$3"; count="$4"

lines=$(wc -l < "$BM_STDOUT_FILE")
lines=$(( lines ))
if (( lines != count )); then
  echo "Expected $count lines but got $lines."
  exit 1
fi

size=$(( high - low + 1 ))
seen=""
while IFS= read -r line; do
  n="${line#slot=}"
  if (( n < low || n > high )); then
    echo "slot=$n is outside the range $low to $high."
    exit 1
  fi
  seen="$seen $n "
done < "$BM_STDOUT_FILE"

if (( size <= 4 && count >= 60 )); then
  for (( v = low; v <= high; v++ )); do
    case "$seen" in
      *" $v "*) ;;
      *) echo "The value $v never appeared in $count draws: is the range off by one?"; exit 1 ;;
    esac
  done
fi

again=$(bash solution.sh "$@" 2>/dev/null)
if [[ "$again" != "$(cat "$BM_STDOUT_FILE")" ]]; then
  echo "Running twice with the same seed gave different output. Did you set RANDOM=\$SEED first?"
  exit 1
fi
exit 0
