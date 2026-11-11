#!/usr/bin/env bash
set -euo pipefail

SITE=${1:-}
if [[ -z $SITE ]]; then
  echo "usage: solution.sh SITE" >&2
  exit 2
fi

source fixtures/defaults.sh

# These definitions come AFTER the library's, so they replace it. Had we written
# them first, sourcing would have overwritten them with the defaults.
retention_days() {
  echo 90
}

notify() {
  echo "[ops-desk] $*"
}

# report is still the library's version, but it looks up notify and
# retention_days by name each time it runs, so it now uses ours.
report "$SITE"
