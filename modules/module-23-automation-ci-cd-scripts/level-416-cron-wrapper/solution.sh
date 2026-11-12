#!/usr/bin/env bash
set -euo pipefail
# Run "$@" (after NAME) under a lock and with a log, the way a cron job
# should: one copy at a time, output kept, exit status preserved.

# TODO 1: validate NAME and that a command follows; create locks/ and logs/.
# TODO 2: take the lock with mkdir; if it is already taken, log "skipped" and
#         exit 0 WITHOUT touching the other run's lock.
# TODO 3: only after you own the lock, set a trap that removes it on exit
#         (and turn INT/TERM into a normal exit so the trap runs).
# TODO 4: log the start line, run the command with stdout and stderr appended
#         to the log, and keep its exit status without dying early.
# TODO 5: log the finish line and exit with the command's status.
