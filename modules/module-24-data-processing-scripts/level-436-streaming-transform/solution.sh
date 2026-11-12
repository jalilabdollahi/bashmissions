#!/usr/bin/env bash
# A filter: stdin in, stdout out. Input "ts,cents" rows; output
# "ts,amount,running" with dollars written from integer cents.
# Process one line at a time. No temp files, no storing of lines.

# TODO 1: one awk program (or a while-read loop) over stdin; strip \r.
# TODO 2: line 1 is the header: print the new header. Blank lines: skip.
# TODO 3: a good row has a ts and cents matching ^-?[0-9]+$ ; otherwise print
#         "bad line N: ..." to stderr and move on.
# TODO 4: keep running (cents) and rows; write a small function that turns cents
#         into dollars with a sign and two digits using / and % on integers.
# TODO 5: at the end of input print "# rows=... total=..." (but only if there
#         was any input).
