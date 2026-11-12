#!/usr/bin/env bash
set -euo pipefail
# Bump a semantic version: $1 is "1.9.9" or "v1.9.9", $2 is major|minor|patch.
# Print only the new version. Reject anything that is not strict MAJOR.MINOR.PATCH.

# TODO 1: two arguments, and $2 must be one of the three parts (case works well).
# TODO 2: one regex for the whole version, with a group for the optional "v"
#         and one group per number; no leading zeros.
# TODO 3: take the groups out of BASH_REMATCH into major, minor, patch.
# TODO 4: a case on the part decides which number grows and which reset to 0.
# TODO 5: print prefix + the three numbers joined with dots.
