#!/usr/bin/env bash
# "$1": <id> <priority> <age_days> <owner> <status>, one ticket per line.
# Print "<id> <owner> <age_days>" for tickets that are P1, open, and
# older than 3 days.

# TODO: awk 'CONDITION { ACTION }' file
#   - CONDITION compares fields: text with ==, numbers with >,
#     and joins tests with &&
#   - ACTION prints the three fields you need
