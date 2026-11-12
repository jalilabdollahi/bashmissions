#!/usr/bin/env bash
# Circuit breaker whose memory lives in a file, so separate processes share it.
set -euo pipefail

usage() {
  echo "usage: solution.sh STATE run NOW CMD [ARGS...] | status NOW | reset" >&2
  exit 2
}

is_uint() { [[ $1 =~ ^[0-9]+$ ]]; }
is_posint() { [[ $1 =~ ^[1-9][0-9]*$ ]]; }

threshold=${THRESHOLD:-3}
cooldown=${COOLDOWN:-30}
is_posint "$threshold" || { echo "invalid THRESHOLD" >&2; exit 2; }
is_posint "$cooldown" || { echo "invalid COOLDOWN" >&2; exit 2; }

[[ $# -ge 2 ]] || usage
state_file=$1
mode=$2
shift 2
tmp=

cleanup() { [[ -n $tmp ]] && rm -f "$tmp"; return 0; }
trap cleanup EXIT

state=closed failures=0 opened_at=0

load_state() {
  [[ -e $state_file ]] || return 0
  local key val seen=0
  while IFS='=' read -r key val; do
    case $key in
      state)
        [[ $val == closed || $val == open || $val == half-open ]] || corrupt
        state=$val; seen=$((seen + 1)) ;;
      failures)  is_uint "$val" || corrupt; failures=$val; seen=$((seen + 1)) ;;
      opened_at) is_uint "$val" || corrupt; opened_at=$val; seen=$((seen + 1)) ;;
      *) corrupt ;;
    esac
  done < "$state_file"
  (( seen == 3 )) || corrupt
}

corrupt() {
  echo "corrupt state file $state_file" >&2
  exit 2
}

# save_state: temp file in the same directory, then rename = atomic replace.
save_state() {
  tmp=$(mktemp "$state_file.XXXXXX")
  printf 'state=%s\nfailures=%s\nopened_at=%s\n' "$state" "$failures" "$opened_at" > "$tmp"
  mv -f "$tmp" "$state_file"
  tmp=
}

say() { echo "breaker: $*" >&2; }

run_guarded() {
  local now=$1 status=0
  shift
  if [[ $state == open ]]; then
    if (( now - opened_at < cooldown )); then
      say "circuit open, call skipped (retry in $((cooldown - (now - opened_at))) s)"
      exit 75
    fi
    state=half-open
  fi
  # `|| status=$?` keeps set -e from killing us when the command fails.
  "$@" || status=$?
  if [[ $state == half-open ]]; then
    if (( status == 0 )); then
      state=closed failures=0 opened_at=0
      say "probe succeeded, circuit CLOSED"
    else
      state=open opened_at=$now
      say "probe failed, circuit OPEN again"
    fi
  elif (( status == 0 )); then
    failures=0
    say ok
  else
    failures=$((failures + 1))
    if (( failures >= threshold )); then
      state=open opened_at=$now
      say "failure $failures/$threshold, circuit OPEN"
    else
      say "failure $failures/$threshold"
    fi
  fi
  save_state
  exit "$status"
}

show_status() {
  local now=$1
  case $state in
    closed) echo "closed (failures $failures/$threshold)" ;;
    half-open) echo "half-open (probe due)" ;;
    open)
      if (( now - opened_at < cooldown )); then
        echo "open (probe in $((cooldown - (now - opened_at))) s)"
      else
        echo "open (probe due)"
      fi ;;
  esac
}

case $mode in
  run)
    [[ $# -ge 2 ]] && is_uint "$1" || usage
    load_state
    now=$1
    shift
    run_guarded "$now" "$@"
    ;;
  status)
    [[ $# -eq 1 ]] && is_uint "$1" || usage
    load_state
    show_status "$1"
    ;;
  reset)
    [[ $# -eq 0 ]] || usage
    rm -f "$state_file"
    echo "breaker reset"
    ;;
  *) usage ;;
esac
