#!/usr/bin/env bash
set -e

# The XXXXXX become random characters; TMPDIR keeps this portable (macOS mktemp
# ignores TMPDIR when called with no template).
tmp=$(mktemp "${TMPDIR:-/tmp}/list.XXXXXX")

trap 'rm -f "$tmp"' EXIT       # registered before anything can fail

sort -u "$1" > "$tmp"
lanternupload "$tmp"
echo "sent clean copy of $1"
