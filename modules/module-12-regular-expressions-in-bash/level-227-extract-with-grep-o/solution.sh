#!/usr/bin/env bash
# List each distinct IPv4-looking address (1-3 digits, four groups, dots) found in
# the log file given as argument 1: one per line, sorted, no repeats.
# TODO: usage check (exit 2); then grep -o -E to pull out only the addresses;
# TODO: sort -u them; remember that grep exits 1 when it finds nothing.
set -euo pipefail
cat "${1:-/dev/null}"
