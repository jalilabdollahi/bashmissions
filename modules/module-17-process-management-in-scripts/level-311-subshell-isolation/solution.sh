#!/usr/bin/env bash
# Give `probe` a debug-level, labelled environment inside a subshell, report
# the subshell's exit status, then show that the main script is unchanged.

# TODO: usage error (stderr, exit 2) when LABEL is missing
# TODO: LOG_LEVEL=info, exported
# TODO: ( set + export LOG_LEVEL=debug and PROBE_LABEL, run probe, exit 7 ) with the status captured
# TODO: print "subshell exited with N"
# TODO: run probe again and print "main LOG_LEVEL=..."
