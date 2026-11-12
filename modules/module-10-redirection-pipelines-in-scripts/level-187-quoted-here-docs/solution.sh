#!/usr/bin/env bash
# Generate cron-<JOB>.sh with four literal lines (the $ signs must survive
# untouched), then say which file was written.

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh JOB" >&2
  exit 2
fi
job=$1

# TODO: write the four lines of the wrapper into "cron-$job.sh"
# TODO: print the confirmation line
