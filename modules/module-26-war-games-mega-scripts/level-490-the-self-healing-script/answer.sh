#!/usr/bin/env bash
# Self-healing watchdog: detect, remediate, verify, escalate, and know when to stop.
set -euo pipefail

usage() {
  echo "usage: solution.sh PLAYBOOK STATE" >&2
  exit 2
}
[[ $# -eq 2 ]] || usage
playbook=$1 state=$2
[[ -r $playbook ]] || usage

is_posint() { [[ $1 =~ ^[1-9][0-9]*$ ]]; }
grace=${GRACE:-5}
max_actions=${MAX_ACTIONS:-6}
flap_limit=${FLAP_LIMIT:-3}
is_posint "$grace" || { echo "invalid GRACE" >&2; exit 2; }
is_posint "$max_actions" || { echo "invalid MAX_ACTIONS" >&2; exit 2; }
is_posint "$flap_limit" || { echo "invalid FLAP_LIMIT" >&2; exit 2; }

# --- parse and validate the playbook before touching anything --------------
services=()
declare -A plan count
n=0
while read -r svc actions _; do
  n=$((n + 1))
  [[ -z $svc || $svc == \#* ]] && continue
  IFS=, read -ra list <<< "$actions"
  for a in "${list[@]}"; do
    case $a in
      restart|clear-cache|rotate-logs|failover) ;;
      *) echo "playbook line $n: unknown action $a" >&2; exit 2 ;;
    esac
  done
  services+=("$svc")
  plan[$svc]=${actions//,/ }
  count[$svc]=0
done < "$playbook"

# --- single instance: mkdir is atomic ---------------------------------------
lock=$state.lock
if ! mkdir "$lock" 2>/dev/null; then
  echo "another healer is running" >&2
  exit 1
fi
trap 'rm -rf "$lock"' EXIT

# --- previous run's counters -------------------------------------------------
if [[ -r $state ]]; then
  while read -r svc c _; do
    [[ -n $svc && -n ${plan[$svc]:-} && ${c:-} =~ ^[0-9]+$ ]] && count[$svc]=$c
  done < "$state"
fi

healthy_now() { svcctl status "$1" > /dev/null 2>&1; }

used=0 n_healthy=0 n_healed=0 n_failed=0
for svc in "${services[@]}"; do
  rc=0
  svcctl status "$svc" > /dev/null 2>&1 || rc=$?
  if (( rc == 0 )); then
    echo "$svc: healthy"
    count[$svc]=0
    n_healthy=$((n_healthy + 1))
    continue
  fi
  if (( rc == 3 )); then
    echo "$svc: unknown service"
    n_failed=$((n_failed + 1))
    continue
  fi
  if (( count[$svc] >= flap_limit )); then
    echo "$svc: flapping (${count[$svc]} heals), paging instead"
    pagerctl notify "$svc" "flapping after ${count[$svc]} heals"
    n_failed=$((n_failed + 1))
    continue
  fi
  attempts=0 healed=0 skipped=0
  for action in ${plan[$svc]}; do
    if (( used >= max_actions )); then
      skipped=1
      break
    fi
    svcctl "$action" "$svc"
    used=$((used + 1))
    attempts=$((attempts + 1))
    sleep "$grace"
    if healthy_now "$svc"; then
      healed=1
      echo "$svc: healed by $action (attempt $attempts)"
      break
    fi
  done
  if (( healed )); then
    count[$svc]=$((count[$svc] + 1))
    n_healed=$((n_healed + 1))
  elif (( skipped )); then
    echo "$svc: skipped (action budget exhausted)"
    n_failed=$((n_failed + 1))
  else
    echo "$svc: UNHEALED after $attempts actions"
    pagerctl notify "$svc" "unhealed after $attempts actions"
    n_failed=$((n_failed + 1))
  fi
done

for svc in "${services[@]}"; do
  echo "$svc ${count[$svc]}"
done | LC_ALL=C sort > "$state"

echo "summary: healthy=$n_healthy healed=$n_healed failed=$n_failed"
(( n_failed == 0 ))
