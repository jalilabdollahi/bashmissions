#!/usr/bin/env bash
set -euo pipefail
# ticket: tracker-cli new --source=cli <everything the caller gave us, untouched>.
# solution.sh passes all its own arguments on to ticket.

# TODO 1: define ticket() { ... } running tracker-cli with the two fixed words first.
# TODO 2: pass the arguments on exactly as received. Quoting decides whether
#         "disk full", "" and "*" survive; try them by hand.
# TODO 3: call ticket with all of this script's arguments.
