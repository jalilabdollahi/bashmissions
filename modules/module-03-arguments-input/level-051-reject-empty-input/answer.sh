#!/usr/bin/env bash
set -euo pipefail

# If stdin is empty, read fails with status 1 and set -e would exit before our own
# check. "|| true" says: a failed read is fine, code simply stays empty.
code=""
read -r code || true

# -z is true when the string has zero length.
[[ -z $code ]] && { echo "error: customer code is empty" >&2; exit 1; }

echo "code accepted: $code"
