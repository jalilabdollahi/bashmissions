#!/usr/bin/env bash
set -euo pipefail
# assert_eq EXPECTED ACTUAL LABEL
# PASS goes to stdout, FAIL (with both values) to stderr and status 1.

# TODO: write assert_eq. Compare as literal strings (quote the right side!).

assert_eq "$1" "$2" "$3"
