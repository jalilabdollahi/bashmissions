#!/usr/bin/env bash
set -euo pipefail

# Each -e adds one rule. "d" deletes the matching line, so it is never printed.
#   ^[[:space:]]*;     optional blanks, then a semicolon: a comment-only line
#   ^[[:space:]]*$     nothing but blanks until the end of the line: a blank line
sed -e '/^[[:space:]]*;/d' -e '/^[[:space:]]*$/d' "$1"
