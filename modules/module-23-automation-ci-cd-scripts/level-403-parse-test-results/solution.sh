#!/usr/bin/env bash
set -euo pipefail
# Summarise the TAP file in $1: count passed / failed / skipped / todo results,
# print one FAIL line per failure, and pick an exit code from the outcome.

# TODO 1: unreadable file -> message on stderr, exit 2.
# TODO 2: read the file line by line; set the four counters and "planned" to 0.
# TODO 3: pick out "1..N" plan lines and "ok" / "not ok" result lines with a
#         regex; the number and description come from BASH_REMATCH.
# TODO 4: look for "# SKIP" or "# TODO" in the line before counting it.
# TODO 5: print the summary, then compare the plan with the number of results.
