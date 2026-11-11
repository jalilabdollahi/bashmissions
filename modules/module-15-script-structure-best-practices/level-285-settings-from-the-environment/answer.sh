#!/usr/bin/env bash
# Health poller settings, taken from the environment.
set -euo pipefail

die() {
  echo "solution.sh: $1" >&2
  exit 2
}

# :- supplies the default when the variable is unset OR empty, and keeps
# "set -u" quiet because the expansion always has a value.
host=${POLL_HOST:-}
seconds=${POLL_SECONDS:-30}
mode=${POLL_MODE:-normal}

[ -n "$host" ] || die "POLL_HOST is required"

# Digits only first (so the arithmetic below never sees text), then the range.
if ! [[ $seconds =~ ^[0-9]{1,5}$ ]] || (( 10#$seconds < 1 || 10#$seconds > 3600 )); then
  die "POLL_SECONDS must be a whole number from 1 to 3600"
fi

case "$mode" in
  fast|normal) ;;
  *) die "POLL_MODE must be fast or normal" ;;
esac

echo "host=$host every=$((10#$seconds))s mode=$mode"
