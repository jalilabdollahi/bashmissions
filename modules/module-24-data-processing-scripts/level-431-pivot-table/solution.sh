#!/usr/bin/env bash
# "$1": CSV "region,plan,signups". Print a pivot: regions down, plans across,
# with a total column and a total row.

# TODO 1: awk -F, ; skip the header and blank lines; report non-integer signups
#         as "skipped line N" on stderr and ignore them.
# TODO 2: cell[$1, $2] += $3, plus row totals, column totals and a grand total.
#         Remember each distinct region and plan the first time you see it.
# TODO 3: write a small insertion-sort function and sort the two name lists.
# TODO 4: in END print the header, one line per region, then the total row;
#         cells nobody filled are 0.
