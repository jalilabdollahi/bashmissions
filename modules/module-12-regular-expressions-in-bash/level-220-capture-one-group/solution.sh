#!/usr/bin/env bash
# From auth-log lines on stdin print the username of every
#   "Failed password for <user> from ..." line, one name per line.
# TODO: write a regex with ( ) around the username (one word, no spaces)
# TODO: print ${BASH_REMATCH[1]} only when the match succeeded
while IFS= read -r line || [[ -n $line ]]; do
  echo "$line"
done
