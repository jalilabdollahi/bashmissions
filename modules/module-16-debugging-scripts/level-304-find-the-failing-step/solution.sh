#!/usr/bin/env bash
set -euo pipefail
# Which release step breaks? solution.sh STEPS_FILE (one step name per line).
# try-steps K rehearses the first K steps; it fails if the broken step is among them.

mapfile -t steps < "$1"
n=${#steps[@]}

# TODO 1: if all n steps pass, print "all N steps pass" and stop.
# TODO 2: otherwise search positions lo..hi (start 1..n). Ask about the middle:
#         if the first mid steps fail, the culprit is at mid or before (hi=mid),
#         else it is after mid (lo=mid+1). Repeat until lo == hi.
# TODO 3: print "first failing step: K NAME". Remember the array starts at 0.
