#!/usr/bin/env bash
set -euo pipefail

used="$1"

# Most severe first: the ladder stops at the first true test,
# so 95 is CRITICAL even though it is also "at least 70".
if [[ $used -eq 100 ]]; then
  echo "$used% used: FULL"
elif [[ $used -ge 90 ]]; then
  echo "$used% used: CRITICAL"
elif [[ $used -ge 70 ]]; then
  echo "$used% used: WARNING"
else
  echo "$used% used: OK"
fi
