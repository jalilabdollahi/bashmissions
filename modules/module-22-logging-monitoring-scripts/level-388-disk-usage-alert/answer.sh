#!/usr/bin/env bash
# Disk usage alert built on the portable output of df -P.
set -euo pipefail

limit=${1:-}
if [[ ! $limit =~ ^[0-9]+$ ]] || (( limit < 1 || limit > 100 )); then
  echo "usage: solution.sh LIMIT" >&2
  exit 2
fi

# Capture first: a failing df inside a pipe would be easy to miss.
if ! table=$(df -P); then
  echo "df failed" >&2
  exit 3
fi

alerts=0
{
  read -r _header                       # first line is just the titles
  while read -r device _blocks _used _avail pct mount; do
    [[ $device == /dev/* ]] || continue
    pct=${pct%\%}                       # "92%" -> "92"
    if (( pct >= limit )); then
      echo "ALERT $mount at $pct%"
      alerts=$((alerts + 1))
    fi
  done
} <<< "$table"

if (( alerts > 0 )); then
  exit 1
fi
echo "all filesystems below $limit%"
