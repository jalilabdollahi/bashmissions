#!/usr/bin/env bash
# Theo's cleanup, version 2. Enter the release folder (argument 1), delete the
# *.old files inside it, report. If the folder cannot be entered, stop BEFORE
# the delete runs, or it will wipe the *.old files of whatever directory
# we happen to be standing in.

cd "$1"

rm -f -- ./*.old
echo "cleaned $1"

# TODO: make the cd above stop the script when it fails. Message to stderr:
#   deploy: cannot enter DIR      then exit 1
