#!/usr/bin/env bash
# A hand-made job queue: WORKERS background loops each take every WORKERS-th
# job from the queue file, deploy it, and print one result line. Collect all
# the lines, sort them, report.

# TODO: usage error (exit 2) / "cannot read QUEUE" (exit 1)
# TODO: a function worker ID that reads the queue, skips blanks and # lines,
#       numbers the jobs, and handles those where number % WORKERS == ID
# TODO: start WORKERS of them with &, wait, and sort everything they print
# TODO: print the sorted lines and the "N jobs, F failed" summary
