#!/usr/bin/env bash
# Show the three client addresses with the most 404 responses in the log
# given as $1, as "<address>: <count>", busiest first.
# One pipeline: filter the 404 lines, pull out the address, count, rank, trim.

log=$1

# TODO: stop with a message on stderr (exit 1) if the file is missing
# TODO: grep | cut | sort | uniq -c | sort -rn | head | (reformat)
# TODO: say "no 404 responses" when nothing matched
