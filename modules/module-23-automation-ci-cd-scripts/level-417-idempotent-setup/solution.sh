#!/usr/bin/env bash
set -euo pipefail
# Bring this directory to the standard app-server layout. Safe to run any
# number of times: look first, create only what is missing, never overwrite.

# TODO 1: count "created" and "ok" results in two counters.
# TODO 2: group deploy: getent group deploy tells you if it exists.
# TODO 3: the three app/ directories (a -d test before mkdir -p).
# TODO 4: config.env is written once; an existing file stays untouched.
# TODO 5: add "umask 027" to app/profile only if no line is exactly that
#         (grep -qxF); watch out for a last line without a newline.
# TODO 6: the app/current-logs link: ok if it is a link, conflict if it is
#         anything else, otherwise create it. Then print the summary.
