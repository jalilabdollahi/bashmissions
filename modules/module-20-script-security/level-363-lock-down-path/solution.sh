#!/usr/bin/env bash
# Nightly spool report. It calls ls, wc, tr and cat by bare name, so whoever
# controls PATH controls what really runs. Pin PATH before the first one.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi

dir=$1
# TODO: set a trusted PATH on its own line, ABOVE the commands below.
entries=$(ls -1 "$dir" | wc -l | tr -d ' ')
printf 'entries: %s\n' "$entries"
cat "$dir/motd.txt"
