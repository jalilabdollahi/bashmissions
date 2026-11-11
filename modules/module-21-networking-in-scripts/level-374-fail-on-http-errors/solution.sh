#!/usr/bin/env bash
# Look up a customer's plan, but stop trusting a response just because it
# arrived: HTTP errors must make the script fail with a useful exit code.

# TODO: usage check (stderr, exit 2)
# TODO: call the plan endpoint with -sS and --fail; catch curl's exit status
#       without letting set -e abort the script
# TODO: status 22 -> "refused" message, exit 3; other non-zero -> "network error (curl exit N)", exit 4
# TODO: on success print "plan: <body>"
