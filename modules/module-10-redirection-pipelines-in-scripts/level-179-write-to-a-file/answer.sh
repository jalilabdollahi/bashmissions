#!/usr/bin/env bash
host=$1

# ">" opens report.txt for writing and empties it first, so an old report
# can never survive next to a new one.
tide-report "$host" > report.txt
