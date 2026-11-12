#!/usr/bin/env bash
set -euo pipefail
# Mini test harness: solution.sh TESTFILE
# Finds test_* functions in TESTFILE, runs each one, prints a verdict and a total.

passed=0
failed=0

# TODO 1: source "$1".
# TODO 2: loop over the sorted test_* function names (compgen -A function).
# TODO 3: run each in a subshell with output discarded; count and print PASS/FAIL.
#         Careful with set -e and with ((passed++)) when passed is 0.

echo "$passed passed, $failed failed"
# TODO 4: exit 1 when anything failed.
