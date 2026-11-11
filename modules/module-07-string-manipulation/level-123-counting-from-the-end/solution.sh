#!/usr/bin/env bash
# Mask an API key before it goes into a ticket: ./solution.sh KEY
# Show "****" plus the last four characters only.
# TODO: reject keys shorter than 4 characters (message on stderr, exit 1).
# TODO: take the tail of the key counting from the END, then print masked=...
