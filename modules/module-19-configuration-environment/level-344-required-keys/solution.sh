#!/usr/bin/env bash
set -euo pipefail
# Check that every required key (arguments 2..) has a non-empty value in the
# config file ($1). Tell the engineer about ALL missing keys, not just the first.

# TODO 1: check the arguments and that the file is readable (exit 2 otherwise).
# TODO 2: read the file into an associative array: name -> trimmed value.
# TODO 3: loop over the required keys; print "missing: KEY" to stderr for each
#         one with no value and count them.
# TODO 4: report the count and exit 1, or print the "config ok" line.
