#!/usr/bin/env bash
# Top-three invoices using a private, unpredictably named scratch file.
set -euo pipefail

# mktemp picks a fresh name and creates the file in one step (mode 600), so an
# attacker cannot get there first with a symlink.
work=$(mktemp "$TMPDIR/invoices.XXXXXX")

# EXIT fires on success, on errors under set -e and on a normal "exit".
trap 'rm -f "$work"' EXIT

cat > "$work"
sort -rn "$work" | head -n 3
