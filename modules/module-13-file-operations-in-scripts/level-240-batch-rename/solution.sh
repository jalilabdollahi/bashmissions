#!/usr/bin/env bash
# Rename every FOLDER/*.OLD to FOLDER/*.NEW (names only in the output).
# ./solution.sh uploads jpeg jpg
# Never overwrite an existing file; count what was renamed and what was skipped.

# TODO: check the arguments and the folder
# TODO: make a glob that matches nothing expand to nothing (shopt -s nullglob)
# TODO: loop over the matching files; build the new name with ${file%...}
# TODO: skip when the new name exists, otherwise mv
# TODO: print the summary line
