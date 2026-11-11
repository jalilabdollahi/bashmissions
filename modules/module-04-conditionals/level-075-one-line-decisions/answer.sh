#!/usr/bin/env bash
set -euo pipefail

sev="${1:-}"

# A && B || C  means:  if A then B, but C runs if A is false OR if B fails.
# To keep C for the "A is false" case only, B must never fail: the braces group
# the pager call with its own || fallback, and echo always succeeds.
[[ $sev == critical ]] && { notify page-oncall || echo "pager failed" >&2; } || echo "logged: $sev"
