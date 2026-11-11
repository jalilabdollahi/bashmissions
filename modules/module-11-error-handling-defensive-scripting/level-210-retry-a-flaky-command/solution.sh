#!/usr/bin/env bash
# Push to the CDN with a few retries. Argument 1 = MAX attempts.
# "lanternpush" is flaky: sometimes it fails and works a moment later.

max=${1:-}

# TODO 1: if max is not a positive whole number, usage message (stderr), exit 2.
# TODO 2: loop attempt = 1..max, running lanternpush quietly each time.
#         success -> "pushed on attempt K", exit 0
#         failure -> "attempt K failed", short sleep if more attempts remain
# TODO 3: after the loop: "giving up after MAX attempts" to stderr, exit 1.
