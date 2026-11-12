#!/usr/bin/env bash
# Cron analyzer: for one calendar day, expand every crontab job into the minutes it
# occupies and report which jobs run at the same time.
#   solution.sh [--min-shared N] MONTH DOM DOW CRONTAB

# TODO: validate --min-shared and the three day numbers, check the file (exit 2)
# TODO: an awk function that expands a cron field (lists, ranges, steps) into a set
# TODO: parse each line: skip comments / env / @reboot, handle @aliases, "# runs 25m",
#       warn on bad lines, apply the day-of-month OR day-of-week rule
# TODO: build an occupancy table job x minute, then count shared minutes per pair
# TODO: print the job table, then the overlaps sorted by size; exit 1 when any
