#!/usr/bin/env bash
# Summarise memory from a /proc/meminfo-format file.
set -euo pipefail

file=${1:-}
limit=${2:-}
if [[ -z $file || ! $limit =~ ^[0-9]+$ ]]; then
  echo "usage: solution.sh MEMINFO LIMIT" >&2
  exit 2
fi
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi

declare -A mem
# Each line is "Name:   12345 kB". With IFS=': ' the colon and the spaces all
# separate fields, so key=Name, value=12345, unit=kB (absent for some lines).
while IFS=': ' read -r key value _unit; do
  [[ -n $key ]] && mem[$key]=$value
done < "$file"

if [[ -z ${mem[MemTotal]:-} ]]; then
  echo "no MemTotal in $file" >&2
  exit 3
fi

total=${mem[MemTotal]}
if [[ -n ${mem[MemAvailable]:-} ]]; then
  avail=${mem[MemAvailable]}
else
  avail=$(( ${mem[MemFree]:-0} + ${mem[Buffers]:-0} + ${mem[Cached]:-0} ))
fi

used=$(( total - avail ))
pct=$(( used * 100 / total ))
echo "memory: $(( used / 1024 )) MiB used of $(( total / 1024 )) MiB ($pct%)"

swap_total=${mem[SwapTotal]:-0}
if (( swap_total == 0 )); then
  echo "swap: none"
else
  swap_used=$(( swap_total - ${mem[SwapFree]:-0} ))
  echo "swap: $(( swap_used / 1024 )) MiB used of $(( swap_total / 1024 )) MiB"
fi

if (( pct >= limit )); then
  echo "WARN: memory at $pct% (limit $limit%)"
  exit 1
fi
