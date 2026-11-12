#!/usr/bin/env bash
# Deployment pipeline: build -> test -> deploy -> verify, undoing the deploy on failure.
set -euo pipefail

usage() { echo "usage: solution.sh APP VERSION" >&2; exit 2; }

[[ $# -eq 2 ]] || usage
app=$1
version=$2
if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "error: bad version '$version'" >&2
  exit 2
fi

state=state
lock=$state/$app.lock
mkdir -p "$state"

# Never start twice. The check happens BEFORE the trap is set, otherwise a
# refused second run would delete the first run's lock on its way out.
if [[ -e $lock ]]; then
  echo "error: pipeline already running for $app" >&2
  exit 7
fi
: > "$lock"
trap 'rm -f "$lock"' EXIT

previous=none
if [[ -f $state/$app.version ]]; then
  previous=$(<"$state/$app.version")
fi

log_stage() { printf '%s %s %s %s\n' "$app" "$version" "$1" "$2" >> "$state/pipeline.log"; }

# run_stage NAME COMMAND... : run quietly, report, record, return the status.
run_stage() {
  local name=$1
  shift
  if "$@" > /dev/null 2>&1; then
    echo "stage $name: ok"
    log_stage "$name" ok
  else
    echo "stage $name: FAILED"
    log_stage "$name" fail
    return 1
  fi
}

verify() {
  local attempt
  for attempt in 1 2 3; do
    if harbor-health "$app" > /dev/null 2>&1; then
      echo "stage verify: ok (attempt $attempt)"
      log_stage verify ok
      return 0
    fi
    if (( attempt < 3 )); then
      sleep 5
    fi
  done
  echo "stage verify: FAILED"
  log_stage verify fail
  return 1
}

rollback() {
  if [[ $previous == none ]]; then
    echo "error: no previous version to roll back to" >&2
    exit 6
  fi
  harbor-deploy "$app" "$previous" > /dev/null 2>&1
  echo "rolled back to $previous"
  log_stage rollback ok
}

if ! run_stage build harbor-build "$app" "$version"; then
  echo "pipeline failed at build: nothing was deployed" >&2
  exit 3
fi
if ! run_stage test harbor-test "$app"; then
  echo "pipeline failed at test: nothing was deployed" >&2
  exit 4
fi
if ! run_stage deploy harbor-deploy "$app" "$version" || ! verify; then
  rollback
  echo "pipeline failed: $app $version was rolled back" >&2
  exit 5
fi

printf '%s\n' "$version" > "$state/$app.version"
echo "deployed $app $version (previous: $previous)"
