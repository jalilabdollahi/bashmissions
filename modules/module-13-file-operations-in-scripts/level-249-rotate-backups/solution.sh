#!/usr/bin/env bash
# Rotate FILE.1 .. FILE.3 (FILE.1 = newest), then copy FILE to FILE.1.
# Keep three at most. Print "rotated FILE: N backups kept".

# TODO: usage check; FILE must be a regular file
# TODO: throw away FILE.3 -- the oldest goes first
# TODO: shift FILE.2 -> FILE.3 and FILE.1 -> FILE.2, but only for the ones that exist
# TODO: copy FILE to FILE.1
# TODO: count the backups that exist and print the summary
