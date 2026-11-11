#!/usr/bin/env bash
# Run `integrity-check SERVER` in the background, say that you are checking,
# then wait for that one job and report how it ended (its exit status).

# TODO: usage error (stderr, exit 2) when SERVER is missing
# TODO: start the check with & and keep $! in a variable
# TODO: print "checking SERVER"
# TODO: wait for exactly that PID and store the status it returns
# TODO: print "SERVER: status N" and exit with N
