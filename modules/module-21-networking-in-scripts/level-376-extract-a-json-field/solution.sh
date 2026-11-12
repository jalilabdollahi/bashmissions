#!/usr/bin/env bash
# Print one field of a customer's JSON record, using only sed/grep.
# Example: ./solution.sh c-204 plan   ->   pro

# TODO: usage check for ID and FIELD
# TODO: fetch the record (-sS --fail); on failure say "customer not found: ID"
# TODO: with sed -E, capture what follows "FIELD": up to the next comma, quote or brace
# TODO: nothing captured -> "field not found: FIELD" on stderr, exit 1; otherwise print it
