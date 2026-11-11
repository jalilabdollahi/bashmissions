#!/usr/bin/env bash
set -euo pipefail

quota=$1

# =~ matches the left side against an extended regular expression.
# ^ and $ anchor the pattern to the start and end, so the WHOLE value must be
# digits; [0-9]+ means "one or more digits". "!" negates the test.
[[ ! $quota =~ ^[0-9]+$ ]] && { echo "error: not a whole number: $quota" >&2; exit 1; }

echo "quota set to $quota GB"
