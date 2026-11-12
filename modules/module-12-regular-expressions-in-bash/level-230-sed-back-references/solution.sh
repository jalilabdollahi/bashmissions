#!/usr/bin/env bash
# Filter: copy stdin to stdout, turning every DD/MM/YYYY date into YYYY-MM-DD.
# Everything else on the line stays as it is.
# TODO: one sed -E substitution; put ( ) around day, month and year in the pattern
# TODO: write the replacement with \1 \2 \3 in the new order (and the g flag)
set -euo pipefail
cat
