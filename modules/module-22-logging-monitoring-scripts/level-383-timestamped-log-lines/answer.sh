#!/usr/bin/env bash
# Timestamped log line using the printf %(...)T builtin: no date process needed.
set -euo pipefail

usage() {
  echo "usage: solution.sh WHEN MESSAGE..." >&2
  exit 2
}

[[ $# -ge 2 ]] || usage
when=$1
shift

if [[ $when == now ]]; then
  when=-1                       # printf treats -1 as "the current time"
elif [[ ! $when =~ ^[0-9]+$ ]]; then
  usage
fi

# "$*" joins the remaining arguments with single spaces.
printf '%(%Y-%m-%dT%H:%M:%SZ)T %s\n' "$when" "$*"
