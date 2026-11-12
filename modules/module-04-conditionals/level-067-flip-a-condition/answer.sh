#!/usr/bin/env bash
set -euo pipefail

ip="$1"

# grep -q   quiet, only the exit status matters
# grep -x   the pattern must match the WHOLE line (10.0.0.1 != 10.0.0.15)
# grep -F   fixed text, so the dots are plain dots and not "any character"
# The leading ! flips the answer: the then-branch runs when grep finds NOTHING.
if ! grep -qxF "$ip" allowlist.txt; then
  echo "BLOCK $ip"
else
  echo "allow $ip"
fi
