#!/usr/bin/env bash
# "$1" log, "$2" FROM, "$3" TO. Lines start with an ISO timestamp.
# Print lines with FROM <= timestamp < TO; no date maths, compare as text.

# TODO 1: fewer than 3 arguments -> usage, exit 2. FROM after TO -> error, exit 1
#         (that comparison is text too: [[ $2 > $3 ]]).
# TODO 2: awk with -v from=... -v to=...; strip \r, skip blank lines.
# TODO 3: if $1 does not match the full timestamp shape, report "skipped line NR".
# TODO 4: otherwise print the line when $1 >= from && $1 < to.
