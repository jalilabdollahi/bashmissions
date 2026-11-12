#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 || ! $2 =~ ^[1-9][0-9]*$ ]]; then
  echo "usage: solution.sh ROTA DAY" >&2
  exit 2
fi
rota=$1
day=$2

if [[ ! -r $rota ]]; then
  echo "cannot read $rota" >&2
  exit 1
fi

# -n turns off sed's automatic printing; "${day}p" prints only that line.
name=$(sed -n "${day}p" "$rota")

if [[ -z $name ]]; then
  echo "no one on call for day $day" >&2
  exit 1
fi
echo "day $day: $name"
