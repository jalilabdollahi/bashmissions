#!/usr/bin/env bash
# One table for every crontab in a folder (one file per user): user, schedule,
# command. Skip comments and environment lines; users without jobs get a row.

# TODO: usage / directory check
# TODO: print the header with the shared printf layout
# TODO: loop over the files in name order, skipping hidden files and non-files
# TODO: per line: skip blank/comment/VAR=value; split @special or five fields + command
# TODO: complain on stderr about lines that have no command
# TODO: count jobs and users with jobs; "(no jobs)" row; final summary
