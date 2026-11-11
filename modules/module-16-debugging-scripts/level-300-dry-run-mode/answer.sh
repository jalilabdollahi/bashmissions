#!/usr/bin/env bash
set -euo pipefail

dry_run=0
if [[ ${1:-} == --dry-run ]]; then
  dry_run=1
  shift
fi

if (( $# != 1 )); then
  echo "usage: solution.sh [--dry-run] SITE" >&2
  exit 2
fi
site=$1

# Every side effect goes through run, so there is exactly one place that
# decides between "do it" and "say it".
run() {
  if (( dry_run )); then
    printf 'would run:'
    printf ' %q' "$@"      # the format repeats for each argument
    printf '\n'
  else
    "$@"
  fi
}

run mkdir -p "sites/$site/logs"
run touch "sites/$site/logs/access.log"
run chmod 750 "sites/$site"

if (( dry_run )); then
  echo "dry run only, nothing changed"
else
  echo "provisioned $site"
fi
