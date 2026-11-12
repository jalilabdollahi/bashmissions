#!/usr/bin/env bash
# Aligned terminal dashboard: measure first, then print.
set -euo pipefail

hosts=(); states=(); loads=(); disks=()
width=4                                   # never narrower than the word HOST
swidth=5                                  # ... or than the word STATE

while IFS= read -r line; do
  read -r -a f <<< "$line"                # split into fields
  if (( ${#f[@]} != 4 )); then
    echo "bad line: $line" >&2
    continue
  fi
  hosts+=("${f[0]}"); states+=("${f[1]}"); loads+=("${f[2]}"); disks+=("${f[3]}")
  (( ${#f[0]} > width )) && width=${#f[0]}
  (( ${#f[1]} > swidth )) && swidth=${#f[1]}
done

if (( ${#hosts[@]} == 0 )); then
  echo "no hosts" >&2
  exit 1
fi

# Layout: HOST(width)  STATE(swidth, left)  LOAD(5, right)  DISK(5, right)
printf '%-*s  %-*s  %5s  %5s\n' "$width" HOST "$swidth" STATE LOAD DISK
printf -v rule '%*s' $(( width + swidth + 16 )) ''   # a string of spaces as wide as the table
printf '%s\n' "${rule// /-}"

down=0
alerts=0
for i in "${!hosts[@]}"; do
  printf -v row '%-*s  %-*s  %5s  %5s' "$width" "${hosts[i]}" "$swidth" "${states[i]}" "${loads[i]}" "${disks[i]}"
  pct=${disks[i]%\%}
  if (( pct >= 90 )); then
    row+="  <-- disk"
    alerts=$((alerts + 1))
  fi
  if [[ ${states[i]} != up ]]; then
    row+="  <-- DOWN"
    down=$((down + 1))
  fi
  printf '%s\n' "$row"
done

echo "${#hosts[@]} hosts, $down down, $alerts disk alerts"
