#!/usr/bin/env bash
set -euo pipefail
# Front end for tide-backup: print retention, dest and compress, each followed
# by the layer it came from. Precedence: flag > env (TIDE_*) > file > default.

# TODO 1: declare associative arrays for the layers (flag, file, default).
# TODO 2: walk through the arguments with while / case / shift. Handle both
#         "--name value" and "--name=value", the valueless --compress, and the
#         three error cases (exit 2).
# TODO 3: read the --config file if there was one (exit 1 if unreadable).
# TODO 4: for each setting pick the first layer that has a value; print
#         "name: value (source)".
