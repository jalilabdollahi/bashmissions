#!/usr/bin/env bash
# Print a log file (argument 1) with "lanternfish.internal" replaced by "example.test"
# and "/srv/lanternfish" replaced by "/srv/app", every occurrence on every line.
# TODO: usage check, then sed with two substitutions (the g flag, escaped dots,
# TODO: and a delimiter other than / for the path). Do not edit the file in place.
set -euo pipefail
cat "${1:-/dev/null}"
