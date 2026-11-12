#!/usr/bin/env bash
set -euo pipefail
# Resolve each secret named on the command line from NAME_FILE (a file) or NAME
# (the value itself). Print only how long each secret is and where it came from.

# TODO 1: no arguments -> usage on stderr, exit 2.
# TODO 2: for every name, build the file variable's name and read both variables
#         BY NAME with ${!...:-}. Both non-empty is an error.
# TODO 3: file variable set: read the file with $(<file) (report unreadable or
#         empty); otherwise use the plain variable; otherwise "missing".
# TODO 4: print "NAME: N chars from file|env". Count problems and exit 1 at the
#         end if there was one, but keep going through the other names.
