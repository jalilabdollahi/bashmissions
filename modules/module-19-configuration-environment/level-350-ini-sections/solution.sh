#!/usr/bin/env bash
set -euo pipefail
# Print the value of KEY inside [SECTION] of the INI file.
# Usage: solution.sh FILE SECTION KEY

# TODO 1: check the argument count (exactly 3) and that FILE is readable.
# TODO 2: read the file line by line, trimming blanks. Skip blanks, # and ; lines.
# TODO 3: a "[name]" line changes the state: remember whether we are inside
#         the wanted section. Lines before any header are outside it.
# TODO 4: inside the section, split "key=value" at the first "=", trim both, and
#         remember the value when the key matches (later lines overwrite).
# TODO 5: print the value, or the "missing key" message with exit 1.
