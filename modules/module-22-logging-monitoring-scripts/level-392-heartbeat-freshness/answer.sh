#!/usr/bin/env bash
# Heartbeat freshness by comparing modification times with a reference file.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh STAMP BEAT..." >&2
  exit 2
fi
stamp=$1
shift

if [[ ! -e $stamp ]]; then
  echo "no stamp file: $stamp" >&2
  exit 2
fi

bad=0
for beat in "$@"; do
  name=$(basename "$beat" .beat)
  if [[ ! -e $beat ]]; then
    echo "MISSING $name"
    bad=1
  elif [[ $beat -ot $stamp ]]; then       # -ot: strictly older than
    echo "STALE $name"
    bad=1
  else
    echo "fresh $name"
  fi
done

exit "$bad"
