#!/usr/bin/env bash
# Health check for one service. Argument 1: its config file, which holds a line
# like  port=8080 . Four things can go wrong and each needs its own exit code
# (see the objective), so the monitoring dashboard knows whom to wake up.

config=${1:-}

# TODO: usage error                 -> stderr message, exit 2
# TODO: config file not readable    -> stderr message, exit 3
# TODO: no valid port= line         -> stderr message, exit 4
# TODO: probe fails                 -> stderr message, exit 5
# TODO: otherwise print "healthy: port N"
