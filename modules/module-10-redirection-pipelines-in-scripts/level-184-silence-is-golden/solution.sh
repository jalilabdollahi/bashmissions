#!/usr/bin/env bash
# Ask probe-host about the host in $1 and print "<host> is up" or
# "<host> is down" based ONLY on its exit status. No other output at all.

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh HOST" >&2
  exit 2
fi
host=$1

# TODO: run probe-host quietly inside an if, then print the verdict
