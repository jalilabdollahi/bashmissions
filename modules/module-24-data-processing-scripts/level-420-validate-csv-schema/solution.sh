#!/usr/bin/env bash
# "$1": a ticket CSV, header "id,opened,priority,subject".
# Report problems as "line N: ..." and finish with a valid/invalid verdict
# whose exit status tells the caller whether the file can be trusted.

# TODO 1: awk -F, ; remove a trailing \r from every line first.
# TODO 2: line 1 must equal the expected header; otherwise say so and exit 1.
# TODO 3: skip blank lines; count the others as rows.
# TODO 4: NF != 4, empty $1, priority not in the allowed list -> report with NR.
# TODO 5: in END handle "no lines at all" (NR == 0) and the verdict + exit code.
