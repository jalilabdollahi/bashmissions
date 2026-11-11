#!/usr/bin/env bash
# Severity router. $1 is the severity.
#   critical -> run: notify page-oncall   (if that fails: "pager failed" on stderr, nothing on stdout)
#   otherwise -> print "logged: <severity>"
# One line, built from && and ||.

# TODO: [[ test ]] && { the pager call, with its own failure message } || the logging echo
# TODO: remember that C in "A && B || C" runs when A is false OR when B fails
