#!/usr/bin/env bash
# Bandwidth bill with cents. GB in $1, RATE per GB in $2, SERVERS in $3.
# Print the total and the per-server share, two decimals each, with a $ sign.

# TODO: bash can't multiply 250.5 * 0.12, so let awk do the maths
# TODO: hand the three values to awk with -v
# TODO: use printf "%.2f" so 15.0 shows up as 15.00
