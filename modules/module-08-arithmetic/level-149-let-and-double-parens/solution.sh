#!/usr/bin/env bash
# Theo's old volume report: TOTAL in $1, USED in $2 (GB).
# Show free space, the used percentage, and what status `let` returned.

# TODO: free = TOTAL - USED, computed with the let command
# TODO: save $? straight away, before anything else runs
# TODO: used_pct = USED * 100 / TOTAL with (( ... ))
# TODO: print the three lines in the order from the objective
