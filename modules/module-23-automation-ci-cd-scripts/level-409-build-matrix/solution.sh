#!/usr/bin/env bash
set -euo pipefail
# Build every OS x runtime pair from two comma-separated lists, skipping the
# excluded pairs, and summarise how many jobs passed.

# TODO 1: check both lists look like "a,b,c" (no empty items), else usage + exit 2.
# TODO 2: split each list into an array.
# TODO 3: the remaining arguments are exclusions "os/version": remember them.
# TODO 4: outer loop over systems, inner loop over versions; print "skipped"
#         for an excluded pair and move on.
# TODO 5: run build-job, keep its status without dying, count run and passed.
# TODO 6: print the summary; exit 1 when something failed.
