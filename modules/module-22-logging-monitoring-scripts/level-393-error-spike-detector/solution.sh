#!/usr/bin/env bash
# Error spike detector: count ERROR lines per minute, report minutes at or
# above THRESHOLD as "SPIKE <date> <hh:mm> errors=<n>".

# TODO: validate arguments and that the log is readable
# TODO: keep only real ERROR lines (the third word), cut the minute out of the timestamp
# TODO: count each minute, in order
# TODO: print the spikes and exit 1, or "no spikes"
