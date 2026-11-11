#!/usr/bin/env bash
# "$1" is an access log: <ip> <method> <path> <status>.
# Print "<count> <path>" for every path, most requested first.

# TODO 1: extract the path (field 3, space-separated).
# TODO 2: bring equal paths together, then count them with uniq -c.
# TODO 3: uniq -c pads the count with spaces; strip them so each line starts
#         with the digits.
# TODO 4: order by count, biggest first, then by path for ties.
