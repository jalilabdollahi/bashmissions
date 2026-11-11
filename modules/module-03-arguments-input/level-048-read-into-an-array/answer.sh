#!/usr/bin/env bash
set -euo pipefail

# -a stores the fields in an array instead of separate variables.
# IFS=, in front of read changes the separator for this one command only.
IFS=, read -ra tags

# ${#tags[@]} is the number of elements; [0] and [-1] are the first and last.
echo "count=${#tags[@]} first=${tags[0]} last=${tags[-1]}"
