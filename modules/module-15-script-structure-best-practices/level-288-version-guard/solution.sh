#!/usr/bin/env bash
# Version guard for the deploy helper: solution.sh MINVERSION  (4.4, or just 5)
# Says whether the bash running this script is new enough.
set -euo pipefail

need=${1:-}

# TODO 1: only accept MAJOR or MAJOR.MINOR (digits); otherwise usage, exit 2.
# TODO 2: split $need into need_major / need_minor (minor defaults to 0).
# TODO 3: compare with ${BASH_VERSINFO[0]} and ${BASH_VERSINFO[1]} as numbers.
# TODO 4: if too old: message on stderr (see the objective), exit 1.
echo "ok: bash >= $need"
