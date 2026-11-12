#!/usr/bin/env bash
set -euo pipefail

# level_num NAME -> prints 0..3 so levels can be compared as numbers
level_num() {
  case $1 in
    DEBUG) echo 0 ;;
    INFO)  echo 1 ;;
    WARN)  echo 2 ;;
    ERROR) echo 3 ;;
    *)     echo 1 ;;     # unknown names behave like INFO
  esac
}

# log LEVEL MESSAGE...  - print "[LEVEL] message" on stderr if LEVEL is important enough
log() {
  local level=$1
  shift
  if (( $(level_num "$level") >= $(level_num "${LOG_LEVEL:-INFO}") )); then
    echo "[$level] $*" >&2
  fi
}

pct=$1
log DEBUG "raw argument: $pct"
log INFO "checking disk usage"
if (( pct >= 90 )); then
  log ERROR "disk almost full: $pct%"
elif (( pct >= 75 )); then
  log WARN "disk filling up: $pct%"
fi
echo "checked: $pct%"
