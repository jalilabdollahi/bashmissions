#!/usr/bin/env bash
# Print every line of the file in $1 as |line|, exactly as written in the file.
# TODO: usage check (exit 2), readable check (exit 1), then the read loop.
echo "|$(cat "$1")|"
