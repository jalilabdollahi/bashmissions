#!/usr/bin/env bash
fullest_host=none
fullest_pct=-1
over=0

# "< <(cmd)" runs fleet-disk in the background and hands its output to the loop
# as if it were a file. The loop itself stays in this shell, so we keep our variables.
while read -r host pct; do
  if (( pct > fullest_pct )); then
    fullest_host=$host
    fullest_pct=$pct
  fi
  if (( pct > 80 )); then
    over=$(( over + 1 ))
  fi
done < <(fleet-disk)

if [[ $fullest_host == none ]]; then
  echo "fullest: none"
else
  echo "fullest: $fullest_host (${fullest_pct}%)"
fi
echo "over 80%: $over"
