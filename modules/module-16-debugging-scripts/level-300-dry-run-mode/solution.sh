#!/usr/bin/env bash
set -euo pipefail
# Site provisioning: solution.sh [--dry-run] SITE
# With --dry-run it must only describe what it would do.

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

# TODO: define run(): in dry-run mode print "would run:" and then every word as
#       " %q" (one printf with a format that repeats), then a newline; otherwise
#       execute "$@".

mkdir -p "sites/$site/logs"
touch "sites/$site/logs/access.log"
chmod 750 "sites/$site"

# TODO: send the three commands above through run, and print the final line.
