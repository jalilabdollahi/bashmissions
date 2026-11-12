#!/usr/bin/env bash
total=0
errors=0

# read splits each line on spaces into client, status and the rest (path).
while read -r client status path; do
  total=$(( total + 1 ))
  # Only the status decides; a 5 followed by anything is a server error.
  if [[ $status == 5* ]]; then
    errors=$(( errors + 1 ))
  fi
done

echo "server errors: $errors of $total requests"
