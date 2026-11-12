#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh JOB" >&2
  exit 2
fi
job=$1
lock="run/$job.lock"

mkdir -p run

# mkdir without -p is a test-and-set in ONE step: the kernel lets exactly one
# caller create the folder. Checking "does it exist?" first and creating it
# second would leave a gap in which two copies both pass.
if ! mkdir "$lock" 2>/dev/null; then
  echo "$job is already running (lock: $lock)" >&2
  exit 1
fi

# Registered only AFTER we own the lock, so a loser never removes the
# winner's lock. Runs on success, on failure under set -e, and on exit.
trap 'rmdir "$lock"' EXIT

echo "$job started" >> run/jobs.log
run-job "$job"                 # set -e stops here if the job fails
echo "$job finished" >> run/jobs.log
