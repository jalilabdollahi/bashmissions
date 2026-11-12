#!/usr/bin/env bash
# Version guard for the deploy helper: solution.sh MINVERSION  (4.4, or just 5)
set -euo pipefail

need=${1:-}

# MAJOR or MAJOR.MINOR, digits only. The capture groups land in BASH_REMATCH.
if ! [[ $need =~ ^([0-9]+)(\.([0-9]+))?$ ]]; then
  echo "usage: solution.sh MINVERSION" >&2
  exit 2
fi
need_major=${BASH_REMATCH[1]}
need_minor=${BASH_REMATCH[3]:-0}          # no minor given means .0

have_major=${BASH_VERSINFO[0]}
have_minor=${BASH_VERSINFO[1]}

# Numeric comparison, major first. 10# avoids octal surprises for "08" or "09".
if (( 10#$have_major > 10#$need_major )) ||
   (( 10#$have_major == 10#$need_major && 10#$have_minor >= 10#$need_minor )); then
  echo "ok: bash >= $need"
else
  echo "solution.sh: requires bash $need or newer (running $have_major.$have_minor)" >&2
  exit 1
fi
