#!/usr/bin/env bash
set -euo pipefail
# Stopwatch wrapper. solution.sh COMMAND [ARG...]
# timed runs the command, then reports "timed: COMMAND ARG... took S.mmms" on stderr.

# TODO 1: no arguments -> usage on stderr, exit 2.
# TODO 2: timed(): note EPOCHREALTIME (it looks like 1700000000.123456; remove the dot to get microseconds),
#         run "$@" and keep its exit status even if it fails, note the clock again.
# TODO 3: elapsed milliseconds = (end - start) / 1000; print seconds and milliseconds with
#         printf '%d.%03d', then return the command's status.
# TODO 4: call timed "$@" and exit with its status.
