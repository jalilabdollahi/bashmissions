#!/usr/bin/env bash
# Release tag gatekeeper. Input: one tag per line on stdin.
# Valid = optional "v", then digits.digits.digits, nothing else.
# Print "<tag>: valid" or "<tag>: invalid".
# TODO: write a regex for the shape (anchor both ends) and keep it in a variable.
# TODO: test each line with [[ ... =~ ... ]].
