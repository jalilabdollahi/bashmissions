#!/usr/bin/env bash
# "$1": a CSV with a header row. "$2": wanted columns, e.g. "email,name".
# Print only those columns in that order, looking them up by header name.

# TODO 1: awk -F, with OFS=, and the wanted list passed in with -v.
# TODO 2: on line 1, record each header name's position: pos[$i] = i.
# TODO 3: split the wanted list into an array; any name missing from pos is an
#         error on stderr (exit 1 before anything is printed).
# TODO 4: for every line (header included), build the output from $(pos[...]).
