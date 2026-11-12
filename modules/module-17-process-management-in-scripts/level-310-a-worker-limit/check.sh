#!/usr/bin/env bash
# Replay .calls.log and find the highest number of resize jobs that were
# running together. It must be exactly min(MAX, number of images).
max=${1:-0}
count=$(( $# - 1 ))
want=$(( count < max ? count : max ))
if (( want == 0 )); then
  exit 0
fi
now=0
peak=0
while read -r event _; do
  if [[ $event == start ]]; then
    now=$((now + 1))
    if (( now > peak )); then peak=$now; fi
  elif [[ $event == end ]]; then
    now=$((now - 1))
  fi
done < .calls.log
if (( peak > max )); then
  echo "Up to $peak resize jobs ran together; the limit was $max."
  exit 1
fi
if (( peak < want )); then
  echo "Only $peak resize jobs ever ran together; keep $want busy while there is work left."
  exit 1
fi
exit 0
