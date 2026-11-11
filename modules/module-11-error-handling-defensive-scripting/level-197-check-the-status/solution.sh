#!/usr/bin/env bash
# Is the site in maintenance mode? The status file is the first argument.
# Report it from grep's exit status, not from grep's output.

file=$1

# TODO 1: run grep quietly (-q) for the exact line maintenance=on (-x), and
#         send its error messages to /dev/null.
# TODO 2: on the very next line, copy $? into a variable called status.
# TODO 3: status 0 -> print "maintenance: ON"
#         status 1 -> print "maintenance: off"
#         anything else -> print "cannot read FILE (grep status N)" to stderr, exit 2
