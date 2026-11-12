#!/usr/bin/env bash
# The point of memoizing: whois-lookup must run at most once per domain.
if [[ -f .calls.log ]]; then
  dups=$(sort .calls.log | uniq -d)
  if [[ -n $dups ]]; then
    echo "whois-lookup was called more than once for:"
    echo "$dups"
    echo "Remember each answer in an associative array and reuse it."
    exit 1
  fi
fi
exit 0
