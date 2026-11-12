#!/usr/bin/env bash
# "$1": request log "timestamp METHOD path status ms".
# Print 1xx..5xx and other with count and percent, then "total N".

# TODO 1: one awk pass; strip \r, skip blank lines, total++ for every request.
# TODO 2: class = first digit of $4 if $4 is exactly three digits 1-5, else "other".
# TODO 3: count[class]++.
# TODO 4: in END print the six classes in fixed order (a small loop over the
#         names), percent = 100 * count / total, 0 when total is 0.
