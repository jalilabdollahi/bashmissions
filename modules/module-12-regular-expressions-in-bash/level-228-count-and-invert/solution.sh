#!/usr/bin/env bash
# Summarise an sshd log (argument 1): "entries: N" (lines that are not empty and do
# not start with #) and "failed: M" (real entries containing "Failed password").
# TODO: usage check, then count with grep -c and exclude comments/blank lines with grep -v
# TODO: grep -c prints 0 for no match, but exits 1; keep set -e from stopping you
set -euo pipefail
echo "entries: 0"
echo "failed: 0"
