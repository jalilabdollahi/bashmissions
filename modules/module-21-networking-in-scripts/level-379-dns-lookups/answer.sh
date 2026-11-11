#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh NAME..." >&2
  exit 2
fi

bad=0
for name in "$@"; do
  # dig exits non-zero when it cannot reach a resolver. An unknown name is
  # NOT an error for dig: it simply prints nothing.
  if ! answers=$(dig +short "$name" 2>/dev/null); then
    echo "$name -> lookup failed"
    bad=$((bad + 1))
    continue
  fi

  # Keep only IPv4 lines (drops CNAME targets), then glue them with commas.
  # grep exits 1 on no match, so the "|| true" keeps pipefail quiet.
  addrs=$(printf '%s\n' "$answers" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | paste -sd, - || true)

  if [[ -z $addrs ]]; then
    echo "$name -> no answer"
    bad=$((bad + 1))
  else
    echo "$name -> $addrs"
  fi
done

if (( bad > 0 )); then
  exit 1
fi
