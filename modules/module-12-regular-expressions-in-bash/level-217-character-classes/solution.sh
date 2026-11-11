#!/usr/bin/env bash
# Check rack tags (one per line on stdin). Valid: "rack-", one lowercase letter,
# exactly two digits, nothing else. Print "<tag>: ok" or "<tag>: bad".
# TODO: build the regex from [a-z] and [[:digit:]], anchored with ^ and $
# TODO: right now every tag is called ok, which is not true
while IFS= read -r tag || [[ -n $tag ]]; do
  echo "$tag: ok"
done
