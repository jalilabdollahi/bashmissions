#!/usr/bin/env bash
set -euo pipefail
# Message tidy-up chain. solution.sh STEP... < messages
# Each STEP is a function mw_STEP; a line goes through all of them in order.

# TODO 1: write mw_trim, mw_lower, mw_squeeze, mw_mask, mw_clip (text in $1, result printed).
# TODO 2: keep the STEP arguments in an array; refuse unknown ones (declare -F) before reading input.
# TODO 3: read lines without losing their spaces. For each line run it through the chain:
#         value=$("mw_$step" "$value") for every step, then print [value].
