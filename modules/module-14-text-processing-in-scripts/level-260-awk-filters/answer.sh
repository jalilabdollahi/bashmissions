#!/usr/bin/env bash
set -euo pipefail

# The part before { } is a pattern: the action only runs for lines where it is true.
#   $2 == "P1"   string equality on field 2
#   $3 > 3       numeric comparison (awk sees that $3 looks like a number)
#   $5 == "open" string equality on field 5
awk '$2 == "P1" && $3 > 3 && $5 == "open" { print $1, $4, $3 }' "$1"
