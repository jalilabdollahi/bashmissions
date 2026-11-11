#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh HOST" >&2
  exit 2
fi
host=$1

# /dev/null is a file that accepts any amount of data and keeps none of it.
# We want the exit status only, so both streams go there.
if probe-host "$host" > /dev/null 2>&1; then
  echo "$host is up"
else
  echo "$host is down"
fi
