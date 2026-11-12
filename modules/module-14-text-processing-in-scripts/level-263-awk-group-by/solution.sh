#!/usr/bin/env bash
# "$1": a CSV with header "date,customer,gb".
# Print "<customer>,<rows>,<total gb>" per customer, sorted by customer.

# TODO 1: -F, and skip line 1 (NR > 1 as the pattern).
# TODO 2: two arrays indexed by customer: one counts rows, one adds up gb.
# TODO 3: in END, for (c in rows) print ...
# TODO 4: pipe the awk output into sort for a stable order.
