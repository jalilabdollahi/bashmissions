#!/usr/bin/env bash
# "$1": incident CSV "time,server,summary" (summary may contain commas).
# Print a complete HTML page with an escaped table row per incident.

# TODO 1: write an escape function for & < > (the & rule must come first).
#         In Bash 5.2 put  shopt -u patsub_replacement  before using ${v//&/...}.
# TODO 2: read the header away, then while IFS=, read -r time server summary
#         build the <tr> rows into one variable and count them.
# TODO 3: print the whole page with cat <<EOF, inserting the rows and the count.
# TODO 4: strip \r, skip blank lines, keep a last line without newline.
