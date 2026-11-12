#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LOGFILE" >&2
  exit 2
fi

# -o  print only the matched text, one match per output line
# -E  extended regex: ([0-9]{1,3}\.){3}[0-9]{1,3} = three "n." groups then a last n
# sort -u  sorts and drops duplicates in one step
# With pipefail, grep's "no match" status (1) would fail the whole pipeline, so the
# grep side is wrapped in { ...; } || true to keep an empty result a success.
{ grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$1" || true; } | sort -u
