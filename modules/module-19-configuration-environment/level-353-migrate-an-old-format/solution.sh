#!/usr/bin/env bash
set -euo pipefail
# Convert a v1 proxy config ($1, "Name: value" lines) into a v2 file ($2,
# "key=value" lines with a "version=2" header). Never modify $1, never overwrite $2.

# TODO 1: argument count, readable old file.
# TODO 2: find the first line that is neither blank nor a comment; if it is
#         exactly "version=2", say so and stop (exit 0, no new file).
# TODO 3: refuse to continue when the new file already exists.
# TODO 4: convert line by line into an array: keep comments, drop blanks,
#         split at the first colon, map the four known names, warn about others.
# TODO 5: only now write "version=2" plus the array to the new file; report the count.
