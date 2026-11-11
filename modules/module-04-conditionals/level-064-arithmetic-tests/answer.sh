#!/usr/bin/env bash
set -euo pipefail

used="$1"
quota="$2"

# Inside (( )) variables need no $ and operators work like in school maths.
if (( used > quota )); then
  echo "over quota: $used GB used of $quota GB (+$(( used - quota )) GB)"
else
  echo "within quota: $used GB used of $quota GB ($(( quota - used )) GB left)"
fi
