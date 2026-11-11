#!/usr/bin/env bash
# "$1" is the handover file: engineer first, ticket last, free text between.
# Print "<ticket> <engineer>" for every line.

# TODO: awk already cuts each line into numbered fields. Which variable holds
# the first one, and which one always holds the last, no matter how many
# words the line has?
