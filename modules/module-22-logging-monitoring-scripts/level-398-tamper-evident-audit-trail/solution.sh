#!/usr/bin/env bash
# Tamper-evident audit log. Entry: SEQ|SUM|MESSAGE where SUM is the cksum of
# "PREV|SEQ|MESSAGE" and PREV is the previous entry's SUM (0 for the first).
#   solution.sh append LOG MESSAGE   verify, then add the next entry
#   solution.sh verify LOG           walk the chain, report the first bad line

# TODO: a function that computes the SUM for (prev, seq, message)
# TODO: a verify function that walks the log and tracks the previous SUM
# TODO: append = verify + compute next seq and SUM from the last good entry
# TODO: dispatch on the mode word, usage message otherwise
