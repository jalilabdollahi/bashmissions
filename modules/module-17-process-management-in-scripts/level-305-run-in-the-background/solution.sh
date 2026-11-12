#!/usr/bin/env bash
# Start `snapshot SERVER` for every argument at the same time (in the
# background), remember each process ID in pids.txt, report how many were
# started, then wait for all of them.

# TODO: print the usage line to stderr and exit 2 when there are no arguments
# TODO: loop over the servers; start each snapshot with & at the end of the line
# TODO: right after starting one, append $! to pids.txt
# TODO: print "started N snapshots", then wait
