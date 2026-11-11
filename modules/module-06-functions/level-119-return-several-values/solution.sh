#!/usr/bin/env bash
set -euo pipefail
# ./solution.sh N...   print "min=.. max=.. sum=.." of the given numbers.
# TODO: stats N... - one pass over "$@", then printf "min max sum" on one line.
# TODO: no arguments -> "no numbers given" on stderr, exit 1.
# TODO: unpack with read -r min max sum <<< "$(stats "$@")" and print the result.
