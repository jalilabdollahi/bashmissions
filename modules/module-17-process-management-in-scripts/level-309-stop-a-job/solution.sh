#!/usr/bin/env bash
# Run `soaktest` in the background for GRACE seconds, then stop it if it is
# still going. Either way, collect its exit status and say how it ended.

# TODO: usage error (stderr, exit 2) when GRACE is missing
# TODO: soaktest & ; remember the PID
# TODO: sleep for GRACE seconds
# TODO: if kill "$pid" works -> wait for it, print "soaktest stopped (status N)"
# TODO: otherwise -> wait for it, print "soaktest finished by itself (status N)"
