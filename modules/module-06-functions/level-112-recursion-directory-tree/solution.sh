#!/usr/bin/env bash
# ./solution.sh DIR   print DIR as an indented tree (dirs end with /).
# TODO: if $1 is not a directory, print "no such directory: ..." to stderr, exit 1.
# TODO: write walk DIR INDENT: for each entry in "$DIR"/* print it; when the
#       entry is a directory, call walk again with two more spaces of indent.
# TODO: print the first line "<dir>/", then start the walk.
