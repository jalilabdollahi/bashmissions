#!/usr/bin/env bash
# Daily summary for Gus: one DATE, many log files, one short report.
# Line format: "2026-03-01 08:14:03 ERROR eel upstream timed out"

# TODO: validate DATE and make sure every file is readable
# TODO: one awk pass over all files, keeping only lines of that day
# TODO: it should count levels, errors per host, and the earliest/latest error time
# TODO: print the report; hosts sorted by count (most first), ties by name, top three
