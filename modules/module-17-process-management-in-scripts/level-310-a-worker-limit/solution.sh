#!/usr/bin/env bash
# Resize many images in the background, but never more than MAX at a time.
# Count how many jobs succeed and how many fail, then print a summary.

# TODO: usage error (stderr, exit 2) when there are no arguments; MAX=$1, then shift
# TODO: keep a counter of running jobs
# TODO: before starting a job, while the counter is at MAX, wait -n for one to end
#       and use its status to update the ok/failed counts
# TODO: after the loop, collect the stragglers the same way until none are left
# TODO: print "done: A ok, B failed" and exit 1 if anything failed
