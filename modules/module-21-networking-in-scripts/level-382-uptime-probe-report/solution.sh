#!/usr/bin/env bash
# Probe every service in a list (websites and TCP ports) and print a report.
# The exit status tells cron whether anything is down.

# TODO: usage check for the file argument; refuse unreadable files (exit 2)
# TODO: read the file line by line, skipping blank lines and # comments
# TODO: "http NAME URL" -> status code via curl; "tcp NAME HOST PORT" -> nc -z
# TODO: print UP / DOWN lines with the reasons from the objective, keep two counters
# TODO: finish with the summary line and exit 1 if anything was down
