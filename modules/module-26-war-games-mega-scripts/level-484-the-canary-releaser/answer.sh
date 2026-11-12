#!/usr/bin/env bash
# Canary controller: raise traffic step by step, judge each step, abort on bad data.
set -euo pipefail

usage() {
  echo "usage: solution.sh PLAN METRICS RELEASE" >&2
  exit 2
}
[[ $# -eq 3 ]] || usage
plan=$1 metrics=$2 release=$3

is_posint() { [[ $1 =~ ^[1-9][0-9]*$ ]]; }

soak=${SOAK:-60}
min_reqs=${MIN_REQS:-100}
tolerance=${TOLERANCE_PM:-20}
is_posint "$soak" || { echo "invalid SOAK" >&2; exit 2; }
is_posint "$min_reqs" || { echo "invalid MIN_REQS" >&2; exit 2; }
is_posint "$tolerance" || { echo "invalid TOLERANCE_PM" >&2; exit 2; }

for f in "$plan" "$metrics"; do
  [[ -r $f ]] || { echo "cannot read $f" >&2; exit 2; }
done

# --- plan: validate before touching the load balancer ---------------------
steps=()
prev=0
while read -r step _; do
  [[ -z $step || $step == \#* ]] && continue
  if [[ ! $step =~ ^[0-9]+$ ]] || (( step <= prev || step > 100 )); then
    echo "bad plan: steps must increase and end at 100" >&2
    exit 2
  fi
  steps+=("$step")
  prev=$step
done < "$plan"
if (( ${#steps[@]} == 0 || prev != 100 )); then
  echo "bad plan: steps must increase and end at 100" >&2
  exit 2
fi

# --- metrics: later lines win ---------------------------------------------
declare -A c_reqs c_errs b_reqs b_errs
while read -r step cr ce br be _; do
  [[ -z $step || $step == \#* ]] && continue
  c_reqs[$step]=$cr c_errs[$step]=$ce b_reqs[$step]=$br b_errs[$step]=$be
done < "$metrics"

rate_pm() {   # ERRS REQS -> permille, 0 when there were no requests
  if (( $2 == 0 )); then echo 0; else echo $(( $1 * 1000 / $2 )); fi
}
tenths() { printf '%d.%d%%' $(($1 / 10)) $(($1 % 10)); }

set_weight() {
  if ! lbctl weight "$1"; then
    echo "cannot set weight $1%" >&2
    lbctl weight 0 || true      # best effort: pull the canary out
    exit 3
  fi
}

abort() {   # STEP REASON
  lbctl weight 0 || true
  echo "$release aborted at $1%: $2"
  exit 1
}

for step in "${steps[@]}"; do
  set_weight "$step"
  if (( step == 100 )); then
    echo "step 100%: all traffic on the canary"
    lbctl promote || { echo "cannot promote $release" >&2; exit 3; }
    echo "$release promoted"
    break
  fi
  sleep "$soak"
  if [[ -z ${c_reqs[$step]:-} ]]; then
    abort "$step" "no metrics recorded"
  fi
  if (( c_reqs[$step] < min_reqs )); then
    abort "$step" "only ${c_reqs[$step]} canary requests (need $min_reqs)"
  fi
  crate=$(rate_pm "${c_errs[$step]}" "${c_reqs[$step]}")
  brate=$(rate_pm "${b_errs[$step]}" "${b_reqs[$step]}")
  limit=$((brate + tolerance))
  if (( crate > limit )); then
    abort "$step" "canary $(tenths "$crate") vs baseline $(tenths "$brate") (limit $(tenths "$limit"))"
  fi
  echo "step $step%: canary $(tenths "$crate") baseline $(tenths "$brate") ok"
done
