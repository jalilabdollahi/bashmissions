#!/usr/bin/env bash
# Incident timeline: merge web (A), database (B) and syslog (C) logs inside a
# time window, keep WARN or worse, print one sorted timeline plus a summary.
#   solution.sh FROM TO LOGFILE...

# TODO: validate arguments, timestamps (YYYY-MM-DD HH:MM:SS), window order, files
# TODO: a scratch directory from mktemp -d, removed by a trap
# TODO: an extract function: one awk program that recognises the three formats,
#       normalises timestamp / service / level, and keeps events in the window
# TODO: merge all files and sort by time, then file order, then line number
# TODO: print the timeline (printf '%s %-8s %-5s %s\n') or the "no events" line
# TODO: summary lines: counts, first error, per-service totals
# TODO: exit 1 when a CRIT event is present
