#!/usr/bin/env bash
set -euo pipefail

name="$1"
used="$2"
total="$3"

# "used / total >= 90%" without any division (and without rounding errors):
# multiply both sides by 100 * total and compare used * 100 with total * 90.
# The most severe check goes first, because a 95%-full disk is also >= 75%.
if (( used * 100 >= total * 90 )); then
  echo "$name: CRITICAL"
elif (( used * 100 >= total * 75 )); then
  echo "$name: WARNING"
else
  echo "$name: OK"
fi
