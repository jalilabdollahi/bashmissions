#!/usr/bin/env bash
# Blocklist gatekeeper. For each candidate on stdin print "<candidate> valid|invalid".
# Valid: four decimal numbers (1-3 digits) separated by dots, each 0..255.
# TODO: regex with four ( ) groups for the shape; skip to "invalid" if it does not match
# TODO: then loop over BASH_REMATCH[1..4] and compare each with 255 (use 10# for decimal)
while IFS= read -r addr || [[ -n $addr ]]; do
  echo "$addr valid"
done
