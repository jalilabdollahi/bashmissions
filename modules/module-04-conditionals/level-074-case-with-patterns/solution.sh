#!/usr/bin/env bash
# Archive helper: print the command that unpacks the archive named in $1.
# Pick the command from the END of the name. Unknown endings are an error.

# TODO: case "$file" in
# TODO:   a branch that handles two endings at once (use | between patterns)
# TODO:   put the more specific *.tar.gz BEFORE the general *.gz
# TODO:   *) -> message on stderr, exit 1
