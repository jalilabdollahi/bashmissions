#!/usr/bin/env bash
set -euo pipefail
# Read workers / debug / log_level from the config file in $1, check each one
# against its type, and print the normalised values - or every complaint.

# TODO 1: start with the defaults (2, false, info) and read the file; names that
#         appear in it replace the default (keep the raw text for messages).
# TODO 2: workers: digits only, then 10#value must be between 1 and 64.
# TODO 3: debug: lowercase it, then a case statement maps the accepted words
#         to true or false.
# TODO 4: log_level: lowercase it and accept only the four levels.
# TODO 5: any complaint -> stderr, exit 1, nothing on stdout; else print the three lines.
