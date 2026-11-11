#!/usr/bin/env bash
set -euo pipefail

# awk splits on runs of blanks by default (and ignores leading/trailing ones).
# $1 is the first field, NF is the field count, so $NF is the last field.
# The comma in print adds one space (the output field separator).
awk '{ print $NF, $1 }' "$1"
