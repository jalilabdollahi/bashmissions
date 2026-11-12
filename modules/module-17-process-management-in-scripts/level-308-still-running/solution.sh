#!/usr/bin/env bash
# Start `reindex` in the background, then look at it up to CHECKS times
# (0.1 s apart) to see whether the process is still alive, without waiting.

# TODO: usage error (stderr, exit 2) when CHECKS is missing
# TODO: reindex & ; pid=$!
# TODO: a loop of at most CHECKS rounds; in each, ask kill -0 "$pid"
# TODO: gone -> print "reindex finished", exit 0; alive -> sleep 0.1
# TODO: after the loop print "reindex still running after CHECKS checks", exit 1
