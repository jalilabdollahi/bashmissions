#!/usr/bin/env bash
# Upload a clean copy of a customer list. Argument 1 is the list file.
# The clean copy (sorted, no duplicates) lives in a scratch file; that file
# must never outlive the script, whatever happens.

sort -u "$1" > /tmp/clean-list.txt
lanternupload /tmp/clean-list.txt
echo "sent clean copy of $1"

# TODO 1: set -e at the top.
# TODO 2: replace the fixed /tmp name with a file made by mktemp, kept in a variable.
# TODO 3: trap ... EXIT right after mktemp, deleting that file with rm -f.
