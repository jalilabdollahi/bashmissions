#!/usr/bin/env bash
# "$1": <date> <category> <amount>, one expense per line.
# Print: count=<n> total=<sum> avg=<average>  (two decimals on the money).

# TODO 1: on every line, add field 3 to a running total (awk variables
#         start at 0, no setup needed).
# TODO 2: in an END block, print the summary with printf.
# TODO 3: guard the division so an empty file gives avg=0.00.
