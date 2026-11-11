#!/usr/bin/env bash
# Job-board claim. The existence test and the write are two separate steps, so
# two callers (or an attacker's symlink) can slip between them.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh JOB OWNER" >&2
  exit 2
fi

job=$1
owner=$2
file="claims/$job.owner"

if [[ -e $file ]]; then
  echo "claim failed: $job is already taken" >&2
  exit 1
fi
# TODO: remove the test above. Turn on noclobber, then write with > inside an
# if, so the redirection itself is the "does it already exist?" test.
printf '%s\n' "$owner" > "$file"
printf 'claimed: %s\n' "$job"
