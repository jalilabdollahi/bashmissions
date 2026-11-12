#!/usr/bin/env bash
set -euo pipefail

# The state: one counter per series. It lives in the main shell, so it
# survives from one call to the next.
declare -A counters=([invoice]=0 [ticket]=0)

kind_ok() {
  if [[ -z ${counters[$1]+x} ]]; then
    echo "gen_next: unknown kind '$1'" >&2
    exit 2
  fi
}

# Result in REPLY, not on stdout. A caller using $(gen_next ...) would run
# this in a subshell and the increment would vanish with it.
gen_next() {
  local kind=$1
  kind_ok "$kind"
  counters[$kind]=$(( counters[$kind] + 1 ))
  case $kind in
    invoice) printf -v REPLY 'INV-%04d' "${counters[invoice]}" ;;
    ticket)  printf -v REPLY 'TCK-%03d' "${counters[ticket]}" ;;
  esac
}

while read -r word arg; do
  [[ -z $word ]] && continue
  if [[ $word == reset ]]; then
    kind_ok "$arg"
    counters[$arg]=0
  else
    gen_next "$word"
    echo "$REPLY"
  fi
done
