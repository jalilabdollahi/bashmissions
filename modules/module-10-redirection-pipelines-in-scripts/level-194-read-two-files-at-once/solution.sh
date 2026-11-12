#!/usr/bin/env bash
# Print "<name> -> <address>" for each line of the NAMES file ($1), taking the
# address from the same line number of the ADDRESSES file ($2).
# NAMES comes through the loop's stdin, ADDRESSES through your own fd 3.

# TODO: check both files are readable (stderr message, exit 1)
# TODO: open $2 on descriptor 3
# TODO: while read ... a name, read ONE line from fd 3; fall back to "(none)"
# TODO: close descriptor 3
