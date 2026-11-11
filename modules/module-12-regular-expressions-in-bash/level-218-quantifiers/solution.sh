#!/usr/bin/env bash
# Check ticket references on stdin: CAPITALS, a dash, 3-5 digits, an optional
# "-P" plus one digit, optional trailing spaces. Print "<line>: valid|invalid".
# TODO: one anchored regex using + {m,n} ? and *
# TODO: print the line exactly as it was read, then the verdict
while IFS= read -r line || [[ -n $line ]]; do
  echo "$line: invalid"
done
