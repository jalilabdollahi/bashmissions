#!/usr/bin/env bash
# Log scrubber: stdin to stdout, secrets replaced by [REDACTED]. Three shapes:
# key=value pairs (password, token), "Bearer VALUE", and user:password@ in URLs.
set -euo pipefail

# TODO: replace "cat" with a sed -E filter with one s/// command per shape.
# Capture the part that is safe to keep and put it back with \1.
cat
