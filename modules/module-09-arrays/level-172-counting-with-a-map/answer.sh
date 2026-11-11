#!/usr/bin/env bash
set -euo pipefail
# "=()" makes the empty map count as set (needed under set -u).
declare -A count=()

while IFS= read -r plan || [[ -n $plan ]]; do
  [[ -z $plan ]] && continue
  # ${count[$plan]:-0} is 0 for a plan we have not seen yet.
  # Do not write count[$plan]+=1 on a plain -A array: += appends TEXT,
  # so "1" followed by "1" would become "11".
  count[$plan]=$(( ${count[$plan]:-0} + 1 ))
done

if (( ${#count[@]} > 0 )); then
  # Map order is unspecified, so sort the keys before printing.
  while IFS= read -r plan; do
    echo "$plan: ${count[$plan]}"
  done < <(printf '%s\n' "${!count[@]}" | sort)
fi
