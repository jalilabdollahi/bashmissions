#!/usr/bin/env bash
# Token-bucket limiter with a replayable clock: time comes from the request lines.
set -euo pipefail

usage() {
  echo "usage: solution.sh LIMITS STATE < requests" >&2
  exit 2
}
[[ $# -eq 2 ]] || usage
limits=$1
state=$2
[[ -r $limits ]] || { echo "cannot read $limits" >&2; exit 2; }

declare -A cap spt tokens last
default_cap=
default_spt=

# --- load the rules -------------------------------------------------------
while read -r client c s _; do
  [[ -z $client || $client == \#* ]] && continue
  if [[ $client == '*' ]]; then
    default_cap=$c default_spt=$s
  else
    cap[$client]=$c
    spt[$client]=$s
  fi
done < "$limits"

# --- load the saved buckets -----------------------------------------------
if [[ -r $state ]]; then
  while read -r client t l; do
    [[ -n $client ]] || continue
    tokens[$client]=$t
    last[$client]=$l
  done < "$state"
fi

is_uint() { [[ $1 =~ ^[0-9]+$ ]]; }

# refill CLIENT TS: add whole tokens, keep the fractional progress in last[].
refill() {
  local c=$1 ts=$2 elapsed added
  elapsed=$((ts - last[$c]))
  if (( elapsed > 0 )); then
    added=$((elapsed / spt[$c]))
    tokens[$c]=$((tokens[$c] + added))
    last[$c]=$((last[$c] + added * spt[$c]))
  fi
  # A full bucket cannot bank time.
  if (( tokens[$c] >= cap[$c] )); then
    tokens[$c]=${cap[$c]}
    last[$c]=$ts
  fi
}

allowed=0 denied=0 errors=0 n=0 prev_ts=0
while IFS= read -r line || [[ -n $line ]]; do
  n=$((n + 1))
  [[ -z ${line//[[:space:]]/} || $line == \#* ]] && continue
  read -r ts client cost extra <<< "$line"
  cost=${cost:-1}
  if [[ -n ${extra:-} || -z $client ]] || ! is_uint "$ts" || ! is_uint "$cost" || (( cost < 1 )); then
    echo "line $n: bad request" >&2
    errors=1
    continue
  fi
  if (( ts < prev_ts )); then
    echo "line $n: time goes backwards" >&2
    errors=1
    continue
  fi
  if [[ -z ${cap[$client]:-} ]]; then
    if [[ -z $default_cap ]]; then
      echo "line $n: no limit for $client" >&2
      errors=1
      continue
    fi
    cap[$client]=$default_cap
    spt[$client]=$default_spt
  fi
  prev_ts=$ts
  if [[ -z ${tokens[$client]:-} ]]; then
    tokens[$client]=${cap[$client]}
    last[$client]=$ts
  fi
  refill "$client" "$ts"
  if (( cost > cap[$client] )); then
    echo "$ts $client reject cost=$cost capacity=${cap[$client]}"
    denied=$((denied + 1))
  elif (( tokens[$client] >= cost )); then
    tokens[$client]=$((tokens[$client] - cost))
    echo "$ts $client allow tokens=${tokens[$client]}"
    allowed=$((allowed + 1))
  else
    missing=$((cost - tokens[$client]))
    echo "$ts $client deny retry=$((last[$client] + missing * spt[$client] - ts))"
    denied=$((denied + 1))
  fi
done

echo "summary: allowed=$allowed denied=$denied"

# --- save the buckets, sorted by name -------------------------------------
for client in "${!tokens[@]}"; do
  echo "$client ${tokens[$client]} ${last[$client]}"
done | sort > "$state"

exit "$errors"
