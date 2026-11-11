#!/usr/bin/env bash
set -euo pipefail

# -F';'       fields in the input are separated by semicolons
# -v OFS=','  "print a, b" joins its arguments with a comma
awk -F';' -v OFS=',' '{ print $2, $1, $4 }' "$1"
