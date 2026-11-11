#!/usr/bin/env bash
set -euo pipefail
# Generic retry. solution.sh ATTEMPTS COMMAND [ARG...] runs COMMAND until it succeeds
# or ATTEMPTS runs are used up, and exits with the last status.

# TODO 1: validate: ATTEMPTS is a whole number >= 1 and a command follows, else usage on stderr, exit 2.
# TODO 2: retry(): take ATTEMPTS off the argument list; loop attempt 1..N.
#         Run "$@" so that a failure is captured (set -e must not end the script) and its status kept.
# TODO 3: success -> return 0. Failure -> message on stderr; after the last attempt also "retry: giving up",
#         and return the last status. Otherwise sleep ${RETRY_DELAY:-0} and go again.
# TODO 4: call retry "$@" and leave with its status.
