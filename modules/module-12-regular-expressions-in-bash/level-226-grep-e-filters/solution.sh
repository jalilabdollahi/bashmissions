#!/usr/bin/env bash
# Print the lines of an access log (argument 1) whose status is 401, 403 or 429,
# i.e. the code sits between two spaces after the quoted request. Exit 0 even
# when no line matches; with no argument print the usage message and exit 2.
# TODO: check the argument, then one grep -E call with an alternation in a group
# TODO: remember grep returns 1 when nothing matches and set -e would stop the script
set -euo pipefail
cat "${1:-/dev/null}"
