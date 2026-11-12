#!/usr/bin/env bash
# "$1" CSV (host,region,gb,tier), "$2" region, "$3" minimum GB.
# Keep the header plus the rows that match region, size and tier rules.

# TODO 1: fewer than 3 arguments -> usage on stderr, exit 2.
# TODO 2: hand $2 and $3 to awk with -v (never splice them into the program text).
# TODO 3: line 1 is always printed; strip a trailing \r from every line.
# TODO 4: one pattern joined with &&: region equal, gb looks like a number,
#         the number is >= minimum (force numeric with +0), tier is not retired.
