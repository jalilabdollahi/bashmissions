#!/usr/bin/env bash
# Print "invoice: <name>" for every customer argument, one per line.
# Names like "Tidewater Books" contain spaces and must stay in one piece.
customers=("$@")

# TODO: print one "invoice: ..." line for each element of customers.
# Careful: the expansion decides whether names survive intact.
echo invoice: ${customers[*]}
