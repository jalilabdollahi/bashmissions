#!/usr/bin/env bash
# Never more than SLOTS renders together, and SLOTS (or fewer, if there are
# fewer scenes) really did run together.
slots=$1
[[ -f .calls.log ]] || exit 0
peak=$(awk '
  $1 == "start" { live++; if (live > best) best = live; scenes++ }
  $1 == "end"   { live-- }
  END { print best + 0, scenes + 0 }' .calls.log)
set -- $peak
best=$1
scenes=$2
need=$slots
if (( scenes < slots )); then need=$scenes; fi
if (( best > slots )); then
  echo "$best renders ran together; the semaphore allowed only $slots."
  exit 1
fi
if (( best < need )); then
  echo "At most $best renders ran together; with $slots tokens $need should have."
  exit 1
fi
exit 0
