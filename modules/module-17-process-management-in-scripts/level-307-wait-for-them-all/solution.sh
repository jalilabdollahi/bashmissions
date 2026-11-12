#!/usr/bin/env bash
# Start a vmbackup for every server given, remember all the PIDs, wait for
# them one at a time in the order given, then print each result and a summary.

# TODO: two arrays (or one array of PIDs plus "$@") to remember who is who
# TODO: start every backup with & and push $! onto the PID array
# TODO: only after everything is started, wait "$pid" for each one and keep its status
# TODO: print "SERVER ok" / "SERVER failed (N)" in argument order, then "A ok, B failed"
# TODO: exit 1 if anything failed
