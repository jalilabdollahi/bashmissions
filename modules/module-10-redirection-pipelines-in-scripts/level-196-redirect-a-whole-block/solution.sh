#!/usr/bin/env bash
# Daily capacity report. $1 is the day, the other arguments are host names.
# One brace group produces the whole report; its stdout goes to
# report-<DAY>.txt and its stderr (disk warnings) to report-<DAY>.err.

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh DAY HOST..." >&2
  exit 2
fi
day=$1
shift

# TODO: header, one disk-usage per host, footer: all inside ONE { ...; } group
# TODO: redirect the group's stdout and stderr on its closing brace

echo "wrote report-$day.txt"
