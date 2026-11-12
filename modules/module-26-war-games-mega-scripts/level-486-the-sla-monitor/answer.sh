#!/usr/bin/env bash
# SLA monitor: probe lines in, uptime and error budget per service out.
# Percentages are handled as integer thousandths: 99.5% is 99500.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--strict] SLO PROBES" >&2
  exit 2
}

strict=0
if [[ ${1:-} == --strict ]]; then
  strict=1
  shift
fi
[[ $# -eq 2 ]] || usage
slo=$1 probes=$2
for f in "$slo" "$probes"; do
  [[ -r $f ]] || { echo "cannot read $f" >&2; exit 2; }
done

# pct_to_milli 99.95 -> 99950 (returns 1 if it is not a percentage 0..100)
pct_to_milli() {
  local whole frac
  [[ $1 =~ ^([0-9]{1,3})(\.([0-9]{1,3}))?$ ]] || return 1
  whole=${BASH_REMATCH[1]}
  frac=${BASH_REMATCH[3]:-}
  while (( ${#frac} < 3 )); do frac+=0; done
  REPLY=$((10#$whole * 1000 + 10#$frac))
  (( REPLY <= 100000 ))
}

# fmt_milli 99500 -> 99.500
fmt_milli() { printf '%d.%03d' $(($1 / 1000)) $(($1 % 1000)); }

# --- SLO file --------------------------------------------------------------
names=()
declare -A target first last bad run outages longest seen
n=0
while read -r name tgt extra; do
  n=$((n + 1))
  [[ -z $name || $name == \#* ]] && continue
  if [[ -n ${extra:-} || -z ${tgt:-} ]] || ! pct_to_milli "$tgt"; then
    echo "bad SLO line $n" >&2
    exit 2
  fi
  names+=("$name")
  target[$name]=$REPLY
  bad[$name]=0 run[$name]=0 outages[$name]=0 longest[$name]=0
done < "$slo"

# close_run NAME: a streak of bad minutes just ended (or the data ended).
close_run() {
  local s=$1
  if (( run[$s] > 0 )); then
    outages[$s]=$((outages[$s] + 1))
    (( run[$s] > longest[$s] )) && longest[$s]=${run[$s]}
    run[$s]=0
  fi
  return 0
}

# --- probes ----------------------------------------------------------------
n=0
while read -r epoch svc state extra || [[ -n ${epoch:-} ]]; do
  n=$((n + 1))
  [[ -z ${epoch:-} ]] && continue
  if [[ -n ${extra:-} || -z ${state:-} || ! $epoch =~ ^[0-9]+$ ]] \
     || [[ $state != up && $state != degraded && $state != down ]]; then
    echo "line $n: bad probe" >&2
    continue
  fi
  if [[ -z ${target[$svc]:-} ]]; then
    echo "line $n: no SLO for $svc" >&2
    continue
  fi
  minute=$((epoch / 60))
  if [[ -n ${seen[$svc]:-} ]] && (( minute <= last[$svc] )); then
    echo "line $n: out of order" >&2
    continue
  fi
  if [[ -z ${seen[$svc]:-} ]]; then
    seen[$svc]=1
    first[$svc]=$minute
  else
    gap=$((minute - last[$svc] - 1))      # blind minutes between two probes
    if (( gap > 0 )); then
      run[$svc]=$((run[$svc] + gap))
      bad[$svc]=$((bad[$svc] + gap))
    fi
  fi
  last[$svc]=$minute
  if [[ $state == down || ( $strict == 1 && $state == degraded ) ]]; then
    run[$svc]=$((run[$svc] + 1))
    bad[$svc]=$((bad[$svc] + 1))
  else
    close_run "$svc"
  fi
done < "$probes"

# --- report ----------------------------------------------------------------
breached=0
for svc in "${names[@]}"; do
  if [[ -z ${seen[$svc]:-} ]]; then
    echo "$svc: no data -> NO DATA"
    continue
  fi
  close_run "$svc"
  total=$((last[$svc] - first[$svc] + 1))
  b=${bad[$svc]}
  t=${target[$svc]}
  uptime=$(( (total - b) * 100000 / total ))
  allowed=$(( total * (100000 - t) / 100000 ))
  if (( b * 100000 > total * (100000 - t) )); then
    status=BREACHED
    breached=1
  elif (( b > 0 && b * 100 >= allowed * 80 )); then
    status="AT RISK"
  else
    status=OK
  fi
  echo "$svc: uptime $(fmt_milli "$uptime")% (target $(fmt_milli "$t")%) used $b of $allowed min, outages=${outages[$svc]} longest=${longest[$svc]} min -> $status"
done
exit "$breached"
