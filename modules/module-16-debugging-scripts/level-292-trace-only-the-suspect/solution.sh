#!/usr/bin/env bash
# Backup duration report. $1 = start time, $2 = end time (both in seconds).
# Only the two arithmetic lines are under suspicion, so only they get traced.

echo "report for backup job"

# TODO: start tracing just before the arithmetic...
elapsed=$(( $2 - $1 ))
minutes=$(( elapsed / 60 ))
# TODO: ...and stop right after it.

echo "backup took ${minutes}m"
