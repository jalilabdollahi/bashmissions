#!/usr/bin/env bash
set -euo pipefail
# Invoice rounding. solution.sh nearest|up|down < amounts_in_cents
# One loop for every contract; the rounding rule is a function chosen up front.

# TODO 1: write round_nearest, round_up, round_down (cents in, whole euros printed).
#         Integer arithmetic only: (c + 50) / 100 rounds to nearest; think what adds up to a ceiling.
# TODO 2: missing argument -> usage on stderr, exit 2.
# TODO 3: map the word to a function name and keep it in the variable strategy; unknown word -> exit 2.
# TODO 4: loop over stdin. Skip blanks; non-numbers go to stderr (remember it for the exit status);
#         numbers print "AMOUNTc -> EUROS EUR" using "$strategy".
