#!/usr/bin/env bash
set -euo pipefail
# Logger factory. solution.sh MESSAGE LEVEL...
# make_logger warn  must define log_warn, which prints "[WARN] words...".

message=$1
shift

# TODO 1: write make_logger LEVEL.
#         First validate: only a-z allowed, else error on stderr and exit 2.
#         Then use eval to define log_LEVEL (the level in capitals baked into the body).
# TODO 2: call make_logger for every LEVEL argument.
# TODO 3: call each new logger with MESSAGE, in order. (Same names, again: "log_$level".)
