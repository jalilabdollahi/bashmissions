#!/usr/bin/env bash
# One-screen status board: run every configured check concurrently, collect the
# results in a scratch directory, print them grouped and in config order.
#   solution.sh [--color] [--problems-only] CONFIG

# TODO: parse --color / --problems-only, read CONFIG (exit 2)
# TODO: load and validate every GROUP|NAME|TYPE|TARGET|ARG line first (exit 3)
# TODO: one function per check type that prints "STATE|detail"
# TODO: mktemp -d + trap; start each check in the background writing to its own file; wait
# TODO: read the results back in config order; group by first appearance
# TODO: print the board (padded state words, optional colour, --problems-only filter)
# TODO: overall state (a critical service down = DOWN) and exit status 0 / 1 / 2
