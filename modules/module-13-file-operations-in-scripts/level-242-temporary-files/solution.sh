#!/usr/bin/env bash
# Clean a mailing list in place: lowercase, no blank lines, sorted, unique.
# Do it through a scratch file made by mktemp, and make sure that file is
# removed at the end.
# Prints: kept N of M addresses

# TODO: usage check and "cannot read LIST" check
# TODO: scratch=$(mktemp)  and arrange for it to be deleted on exit
# TODO: lowercase -> drop blank lines -> sort -u, writing into the scratch file
# TODO: copy the scratch file back over the list
# TODO: count before (non-blank lines) and after, print the summary
