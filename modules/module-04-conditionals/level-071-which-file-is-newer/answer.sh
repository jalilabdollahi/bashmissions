#!/usr/bin/env bash
set -euo pipefail

source_file="$1"
backup="$2"

# "a -nt b" is true when a was modified more recently than b.
# It is ALSO true when a exists and b does not, which is exactly the
# right answer for "the backup was never made".
if [[ $source_file -nt $backup ]]; then
  echo "STALE: $backup is older than $source_file"
else
  echo "fresh: $backup is up to date"
fi
