#!/usr/bin/env bash
# Capacity planner: from disk samples (DATE,HOST,MOUNT,USED_GB,TOTAL_GB) fit a
# growth line per disk, project the day it fills up, and raise an alert level.
#   solution.sh [--warn DAYS] [--crit DAYS] FILE

# TODO: parse --warn / --crit (whole numbers), validate, read FILE (exit 3 on errors)
# TODO: awk helpers: days(y,m,d) -> day number, civil(z) -> "YYYY-MM-DD"
# TODO: group samples by host+mount, skip and count malformed lines (stderr warning)
# TODO: least squares slope; used%, days left, full date, status per group
# TODO: sort rows by a computed key, print header + rows with the exact printf format
# TODO: summary line and exit status 0 / 1 / 2
