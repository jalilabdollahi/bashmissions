#!/usr/bin/env bash
# Read image names from stdin and run `thumb NAME` for each one, WORKERS at a
# time, using xargs. Print the "done ..." lines sorted, and fail (exit 1) if
# any thumbnail failed.

# TODO: usage error (stderr, exit 2) when WORKERS is missing
# TODO: xargs with -n 1 (one name per call) and -P "$workers" running thumb
# TODO: sort the combined output
# TODO: turn xargs' failure (status 123) into exit status 1 -- pipefail helps
