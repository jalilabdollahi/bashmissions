#!/usr/bin/env bash
# Disk alert: shout about every real disk that is LIMIT percent full or more.
# Real disks = devices whose name starts with /dev/ (skip tmpfs and similar).

# TODO: validate LIMIT (whole number, 1-100)
# TODO: run df -P and keep its output; exit 3 with "df failed" if it errors
# TODO: skip the header, split each line into columns, strip the % sign
# TODO: print alerts, then exit 1 if any, else the all-clear line
