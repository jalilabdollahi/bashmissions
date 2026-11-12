#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh HOSTFILE IPFILE" >&2
  exit 2
fi

mapfile -t hosts < "$1"
mapfile -t ips < "$2"

# A table shifted by one line is worse than no table: refuse early.
if (( ${#hosts[@]} != ${#ips[@]} )); then
  echo "lists differ in length: ${#hosts[@]} hosts, ${#ips[@]} addresses" >&2
  exit 1
fi

declare -A table=()
for i in "${!hosts[@]}"; do
  table[${hosts[i]}]=${ips[i]}      # same index i in both arrays
done

if (( ${#table[@]} > 0 )); then
  # Sort the keys ourselves: "dory" must come before "dory2", which a sort
  # of the finished "host=ip" lines would get wrong ("2" sorts before "=").
  mapfile -t names < <(printf '%s\n' "${!table[@]}" | sort)
  for h in "${names[@]}"; do
    echo "$h=${table[$h]}"
  done
fi
