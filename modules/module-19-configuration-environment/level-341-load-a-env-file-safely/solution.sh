#!/usr/bin/env bash
set -euo pipefail
# Load the settings in the .env file given as $1 WITHOUT executing it, then
# print name=, port= and motd= (use "(unset)" for missing ones).

# TODO 1: if $1 is not a readable file, say "cannot read ..." on stderr, exit 1.
# TODO 2: read the file line by line, counting lines.
# TODO 3: skip blanks and comments; match KEY=VALUE with a regex and take the
#         key and value from BASH_REMATCH; report other lines as skipped.
# TODO 4: trim the value, remove one pair of surrounding quotes, export it.
# TODO 5: print the three result lines.
