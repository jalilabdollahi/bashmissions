#!/usr/bin/env bash
# Log scrubber: one sed expression per shape of secret.
set -euo pipefail

sed -E \
  -e 's/(password|token)=[^[:space:]&]+/\1=[REDACTED]/g' \
  -e 's/Bearer [^[:space:]]+/Bearer [REDACTED]/g' \
  -e 's#(://[^:/@[:space:]]+):[^@/[:space:]]+@#\1:[REDACTED]@#g'
# Notes on the patterns:
#  - "+" (not "*") means a key with an empty value is not touched.
#  - [^[:space:]&]+ stops at whitespace or at the next query parameter.
#  - The URL rule uses # as the delimiter because the pattern contains slashes.
