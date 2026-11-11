#!/usr/bin/env bash
# Run fetch-logs | scrub-pii | ship-lines and report the exit status of EACH
# stage as "fetch=A scrub=B ship=C". If any stage failed, name the first one
# on stderr and exit 1. Do not use pipefail.

fetch-logs | scrub-pii | ship-lines

# TODO: copy PIPESTATUS into your own array right here, before anything else runs
# TODO: print the status line
# TODO: find the first non-zero stage and report it
