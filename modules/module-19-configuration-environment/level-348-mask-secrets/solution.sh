#!/usr/bin/env bash
set -euo pipefail
# Print the settings of the config file $1 so that they can be pasted into a
# ticket: secret values and URL passwords are masked.

# TODO 1: unreadable file -> "cannot read ..." on stderr, exit 1.
# TODO 2: read NAME=VALUE lines (trim, skip comments/blanks).
# TODO 3: decide if the name is a secret: uppercase it and compare its end with
#         a glob in a case statement. Build "****" plus the last four characters.
# TODO 4: otherwise look for ://USER:PASSWORD@ in the value and mask the password.
# TODO 5: print NAME=VALUE.
