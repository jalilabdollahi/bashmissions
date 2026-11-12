#!/usr/bin/env bash
set -euo pipefail
# A tiny daemon skeleton: load the level from CONFIG ($1), install a HUP handler
# that reloads it, then play the administrator: append "level=$2" and signal self.

# TODO 1: check the arguments (exactly two).
# TODO 2: write ONE function that reads the level from the config file and fails
#         when it is not debug/info/warn/error (last "level" line wins).
# TODO 3: load, print "loaded: level=...", or fail with exit 1.
# TODO 4: write the reload handler (valid: switch level and print; invalid: keep
#         the old one and complain on stderr) and install it with trap ... HUP.
# TODO 5: append the new line to the file, kill -HUP $$, print the final line.
