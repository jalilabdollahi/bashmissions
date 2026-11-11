#!/usr/bin/env bash
# Top-three invoices. Theo keeps the sorted numbers in a scratch file with a
# fixed name. Give the scratch file an unpredictable name and make sure it is
# deleted at the end, even if something fails halfway.
set -euo pipefail

work="$TMPDIR/report.tmp"
cat > "$work"
# TODO: create $work with mktemp, register a trap on EXIT to delete it, then
# sort -rn the file and print only the first three lines.
sort -rn "$work" | head -n 3
