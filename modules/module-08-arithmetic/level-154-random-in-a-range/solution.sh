#!/usr/bin/env bash
# Backup jitter generator: SEED ($1), LOW ($2), HIGH ($3), COUNT ($4).
# Print COUNT lines of "slot=<n>" with LOW <= n <= HIGH.

# TODO: seed the generator so a run can be replayed
# TODO: how many different values are allowed? (count both ends)
# TODO: repeat COUNT times: draw $RANDOM, squeeze it into that many values with %,
#       then shift it up by LOW
