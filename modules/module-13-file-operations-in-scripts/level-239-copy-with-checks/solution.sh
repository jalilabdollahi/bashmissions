#!/usr/bin/env bash
# Copy SOURCE into FOLDER, but only after checking the inputs, and only call
# it a success if the copy really matches the original.
# Exit codes: 1 = bad input, 2 = usage, 3 = corrupt copy.

# TODO: argument count check
# TODO: is the source a readable file? does the folder exist? is the name free?
# TODO: copy, then compare the two files byte for byte
# TODO: on a mismatch remove the bad copy and report it (exit 3)
# TODO: on success print "copied SOURCE -> DEST"
