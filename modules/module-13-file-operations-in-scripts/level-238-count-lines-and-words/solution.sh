#!/usr/bin/env bash
# For every file argument print "FILE: L lines, W words", then a "total:" line.
# Counting must work the same on macOS and Linux.

# TODO: usage check (no arguments -> stderr, exit 2)
# TODO: keep running totals for lines and words
# TODO: loop over the arguments; skip anything that is not a regular file
# TODO: count with wc and "<" and wrap it in $(( )) to drop padding
# TODO: print the total line at the end
