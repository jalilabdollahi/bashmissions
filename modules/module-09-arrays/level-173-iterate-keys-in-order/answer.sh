#!/usr/bin/env bash
set -euo pipefail
reverse=0
if [[ ${1:-} == --reverse ]]; then
  reverse=1
  shift
fi

declare -A rack=()   # "=()": an empty map still counts as set under set -u
for pair in "$@"; do
  # %%=* removes the longest "=..." suffix  -> everything before the first =
  # #*=   removes the shortest "...=" prefix -> everything after the first =
  rack[${pair%%=*}]=${pair#*=}
done

if (( ${#rack[@]} > 0 )); then
  # The map has no order of its own: we create it by sorting the keys.
  if (( reverse )); then
    mapfile -t units < <(printf '%s\n' "${!rack[@]}" | sort -rn)
  else
    mapfile -t units < <(printf '%s\n' "${!rack[@]}" | sort -n)
  fi
  for unit in "${units[@]}"; do
    echo "U$unit: ${rack[$unit]}"
  done
fi
