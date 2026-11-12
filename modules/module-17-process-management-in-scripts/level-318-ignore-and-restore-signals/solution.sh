#!/usr/bin/env bash
# Shield the script from SIGTERM, show that the shield is inherited by the
# programs it starts, then take the shield away and show that it is gone.

# TODO: usage error (stderr, exit 2) when NAME is missing
# TODO: ignore TERM, send TERM to yourself, print "shielded NAME"
# TODO: run worker, keep its status, print "phase 1 (NAME): status N"
# TODO: restore the default action for TERM
# TODO: run worker again, keep its status, print "phase 2 (NAME): status N"
