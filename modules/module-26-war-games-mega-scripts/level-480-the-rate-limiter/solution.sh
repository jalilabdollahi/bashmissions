#!/usr/bin/env bash
# Token-bucket rate limiter. Rules in LIMITS, saved buckets in STATE, requests
# on stdin as "TS CLIENT [COST]". The clock is the TS column, never `date`.
#   solution.sh LIMITS STATE < requests

# TODO: check the arguments and that LIMITS is readable (exit 2 otherwise)
# TODO: load the rules (and the `*` default) into associative arrays
# TODO: load the saved buckets from STATE if it exists
# TODO: a refill function: whole tokens added, LAST moves by tokens x seconds
# TODO: loop over stdin: validate, refill, allow / deny / reject, count
# TODO: print the summary, then rewrite STATE sorted by client
# TODO: exit 1 if any request line was skipped
