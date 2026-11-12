#!/usr/bin/env bash
set -euo pipefail

# First delete the CR characters left by the Windows exporter,
# then squeeze each run of spaces into one. -s only touches the characters
# named in its set, so tabs and newlines pass through unchanged.
tr -d '\r' | tr -s ' '
