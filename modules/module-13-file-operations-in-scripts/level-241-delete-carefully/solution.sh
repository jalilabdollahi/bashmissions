#!/usr/bin/env bash
# Delete the folder given as $1, but ONLY if it lies inside ./shared.
# Every refusal prints one line to stderr (see the objective for the exact
# wording and exit codes) and deletes nothing.

dir=$1

# TODO: refuse a missing argument, an empty string, "/", and non-folders
# TODO: resolve the real path:  resolved=$(cd "$dir" && pwd -P)
# TODO: compare it with the real path of ./shared (itself and "outside" are refused)
# TODO: only then rm -rf the resolved path and print "deleted: DIR"
