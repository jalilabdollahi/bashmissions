#!/usr/bin/env bash
# Daily bandwidth readings arrive on stdin, one per line.
# Print count, sum, min, max and the integer average, in a single pass.

# TODO: keep a counter and a running sum while reading
# TODO: remember the smallest and largest seen so far (what should they start as?)
# TODO: skip blank lines
# TODO: no readings at all -> "no data" on stderr, exit 1
# TODO: print the five lines
