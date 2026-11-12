#!/usr/bin/env bash
# Health poller settings, taken from the environment.
# POLL_HOST (required), POLL_SECONDS (default 30), POLL_MODE (default normal).
# Prints one summary line. Currently it trusts whatever it is given.
set -euo pipefail

host=$POLL_HOST
seconds=$POLL_SECONDS
mode=$POLL_MODE

# TODO 1: give seconds and mode defaults with ${VAR:-default}; treat an empty
#         POLL_HOST as missing (use ${POLL_HOST:-} so set -u stays quiet).
# TODO 2: validate: seconds is 1..3600 and digits only, mode is fast or normal.
#         Errors go to stderr as "solution.sh: <message>" with exit status 2.
echo "host=$host every=${seconds}s mode=$mode"
