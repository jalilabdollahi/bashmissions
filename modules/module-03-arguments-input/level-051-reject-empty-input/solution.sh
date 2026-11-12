#!/usr/bin/env bash
# Billing import, safer version: one customer code comes from stdin and an empty
# answer, or no answer at all, must be turned down with an error on stderr.
# TODO: read the line (without letting a missing line kill the script),
#       reject emptiness, otherwise print the accepted code.
