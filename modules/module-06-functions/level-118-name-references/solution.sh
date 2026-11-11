#!/usr/bin/env bash
set -euo pipefail
# Reads words on stdin and prints them without repeats, in first-seen order.
# TODO: add_unique ARRAYNAME VALUE - use  local -n  to reach the caller's array,
#       loop over it, append VALUE only when it is not there yet.
# TODO: main: seen=(), read lines (skip blanks), add_unique seen "$line",
#       then print "unique: N" and "- element" per element.
