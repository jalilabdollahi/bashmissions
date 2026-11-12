#!/usr/bin/env bash
# Retry wrapper: fixed, linear or exponential back-off, a cap, a total budget,
# and an opinion about which exit codes deserve another try.
set -euo pipefail

usage() {
  echo "usage: solution.sh plan STRATEGY ATTEMPTS DELAY [MAX] | run [--strategy S] [--attempts N] [--delay D] [--max-delay M] [--budget B] [--retry-on C,C] -- COMMAND..." >&2
  exit 2
}

hard_limit=86400
is_uint() { [[ $1 =~ ^[0-9]+$ ]]; }

# wait_after STRATEGY DELAY MAX N -> prints the wait (seconds) after failed attempt N
wait_after() {
  local strategy=$1 delay=$2 max=$3 n=$4 w i
  case $strategy in
    fixed)       w=$delay ;;
    linear)      w=$((delay * n)) ;;
    exponential)
      # double step by step and stop early: a plain shift could overflow at n=64
      w=$delay
      for (( i = 1; i < n; i++ )); do
        w=$((w * 2))
        (( w >= hard_limit )) && break
      done ;;
  esac
  (( max > 0 && w > max )) && w=$max
  (( w > hard_limit )) && w=$hard_limit
  echo "$w"
}

valid_strategy() { [[ $1 == fixed || $1 == linear || $1 == exponential ]]; }

[[ $# -ge 1 ]] || usage
mode=$1
shift

case $mode in
  plan)
    [[ $# -eq 3 || $# -eq 4 ]] || usage
    strategy=$1 attempts=$2 delay=$3 max=${4:-0}
    valid_strategy "$strategy" || usage
    is_uint "$attempts" && (( attempts >= 1 && attempts <= 30 )) || usage
    is_uint "$delay" && is_uint "$max" || usage
    total=0
    for (( n = 1; n < attempts; n++ )); do
      w=$(wait_after "$strategy" "$delay" "$max" "$n")
      echo "after attempt $n: wait ${w}s"
      total=$((total + w))
    done
    echo "total wait: ${total}s"
    ;;
  run)
    strategy=exponential attempts=4 delay=1 max=0 budget=0 retry_on=
    while (( $# > 0 )) && [[ $1 != -- ]]; do
      [[ $# -ge 2 ]] || usage
      case $1 in
        --strategy)  strategy=$2 ;;
        --attempts)  attempts=$2 ;;
        --delay)     delay=$2 ;;
        --max-delay) max=$2 ;;
        --budget)    budget=$2 ;;
        --retry-on)  retry_on=$2 ;;
        *) usage ;;
      esac
      shift 2
    done
    [[ ${1:-} == -- ]] || usage
    shift
    (( $# > 0 )) || usage
    valid_strategy "$strategy" || usage
    is_uint "$attempts" && (( attempts >= 1 && attempts <= 30 )) || usage
    is_uint "$delay" && is_uint "$max" && is_uint "$budget" || usage
    [[ -z $retry_on || $retry_on =~ ^[0-9]+(,[0-9]+)*$ ]] || usage

    retryable() {   # EXIT_CODE
      if [[ -n $retry_on ]]; then
        [[ ",$retry_on," == *",$1,"* ]]
      else
        (( $1 != 126 && $1 != 127 ))
      fi
    }

    waited=0
    for (( n = 1; n <= attempts; n++ )); do
      status=0
      "$@" || status=$?
      if (( status == 0 )); then
        echo "succeeded on attempt $n" >&2
        exit 0
      fi
      if ! retryable "$status"; then
        echo "not retrying: exit $status is not retryable" >&2
        exit "$status"
      fi
      if (( n == attempts )); then
        echo "gave up after $attempts attempts (last exit $status)" >&2
        exit "$status"
      fi
      w=$(wait_after "$strategy" "$delay" "$max" "$n")
      if (( budget > 0 && waited + w > budget )); then
        echo "retry budget of ${budget}s exhausted after $n attempts" >&2
        exit "$status"
      fi
      echo "attempt $n/$attempts failed (exit $status), retrying in ${w}s" >&2
      (( w > 0 )) && sleep "$w"
      waited=$((waited + w))
    done
    ;;
  *) usage ;;
esac
