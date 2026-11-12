#!/usr/bin/env bash
# A tiny signal-driven "daemon" tested from the inside: USR1 toggles verbose
# mode, USR2 prints a status line, and the actions on the command line
# trigger those signals by sending them to this very script.

# TODO: usage error (stderr, exit 2) when there are no actions
# TODO: verbose=off, steps=0
# TODO: two small functions (toggle, status) and trap them on USR1 and USR2
# TODO: loop over the actions with a case: go / verbose / status / unknown
# TODO: "verbose" and "status" must send the signal with kill -SIG $$
