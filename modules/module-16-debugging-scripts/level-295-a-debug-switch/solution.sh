#!/usr/bin/env bash
set -euo pipefail
# Port reservation: $1 = server, $2 = number of sites, two ports per site.
# Silent normally; with DEBUG=1 in the environment it explains its numbers.

# TODO: write a debug() function that prints "debug: <args>" to stderr
#       only when DEBUG is 1. Mind set -u (DEBUG may not exist) and
#       set -e (the function must succeed even when it stays silent).

# TODO: call debug "sites=$2" before the arithmetic, debug "last=$last" after.

first=8000
last=$(( first + 2 * $2 - 1 ))
echo "$1 uses ports $first-$last"
