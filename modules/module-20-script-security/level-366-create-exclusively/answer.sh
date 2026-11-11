#!/usr/bin/env bash
# Claim a job atomically: the redirection is the check and the creation at once.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh JOB OWNER" >&2
  exit 2
fi

job=$1
owner=$2
file="claims/$job.owner"

# With noclobber, ">" refuses to touch an existing path. Bash creates a new file
# with O_EXCL, which also refuses symlinks, dangling ones included.
set -o noclobber

# The braces let us hide the shell's own "cannot overwrite" message and decide
# what to say ourselves.
if { printf '%s\n' "$owner" > "$file"; } 2>/dev/null; then
  printf 'claimed: %s\n' "$job"
else
  printf 'claim failed: %s is already taken\n' "$job" >&2
  exit 1
fi
