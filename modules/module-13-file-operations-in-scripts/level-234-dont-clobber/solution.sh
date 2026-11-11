#!/usr/bin/env bash
# Save TEXT into FILE, but never replace an existing file by accident.
# Turn on the shell's overwrite protection; only "--force" may override it.

file=$1
text=$2
force=${3:-}

echo "$text" > "$file"
# TODO: check the arguments first (usage message, exit 2)
# TODO: switch on noclobber
# TODO: with --force overwrite on purpose; otherwise refuse quietly with exit 1
# TODO: print "wrote FILE" after a successful write
