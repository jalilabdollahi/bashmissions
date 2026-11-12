#!/usr/bin/env bash
# Count ERROR lines per minute and flag minutes over a threshold.
set -euo pipefail

log=${1:-}
limit=${2:-}
if [[ -z $log || ! $limit =~ ^[0-9]+$ ]] || (( limit < 1 )); then
  echo "usage: solution.sh LOGFILE THRESHOLD" >&2
  exit 2
fi
if [[ ! -r $log ]]; then
  echo "cannot read $log" >&2
  exit 2
fi

spikes=0
# Characters 1-16 of "2026-03-01 14:05:17 ..." are "2026-03-01 14:05".
# The grep pattern pins ERROR to the third word, so messages that merely
# mention ERROR are not counted. "|| true": grep exits 1 when nothing matches.
while read -r count day minute; do
  if (( count >= limit )); then
    echo "SPIKE $day $minute errors=$count"
    spikes=$((spikes + 1))
  fi
done < <( { grep -E '^[0-9-]+ [0-9:]+ ERROR ' "$log" || true; } | cut -c1-16 | sort | uniq -c )

if (( spikes > 0 )); then
  exit 1
fi
echo "no spikes"
