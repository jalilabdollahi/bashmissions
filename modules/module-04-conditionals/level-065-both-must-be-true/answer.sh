#!/usr/bin/env bash
set -euo pipefail

user="$1"
group="$2"
mfa="$3"

# && between two tests inside [[ ]]: true only when BOTH are true.
# If the first is false, Bash does not even look at the second.
if [[ $group == staff && $mfa == yes ]]; then
  echo "granted: $user"
else
  echo "denied: $user"
fi
