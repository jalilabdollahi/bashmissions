#!/usr/bin/env bash
# Print a cksum manifest (CRC SIZE PATH) of every *.log file below DIR, sorted.
# File names can contain spaces, quotes and other awkward characters, so the
# names must travel from find to cksum separated by NUL bytes.

# TODO: usage error (exit 2) for a missing DIR; "not a folder: DIR" (exit 1)
# TODO: find "$dir" for regular files named *.log, printing names with -print0
# TODO: hand them to cksum with xargs -0
# TODO: sort the result
