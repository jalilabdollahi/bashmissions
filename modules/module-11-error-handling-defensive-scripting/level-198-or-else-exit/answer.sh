#!/usr/bin/env bash

# If cd fails we are still in the old directory. Stop before rm can run there.
cd "$1" 2>/dev/null || {
  echo "deploy: cannot enter $1" >&2
  exit 1
}

rm -f -- ./*.old     # -f: no complaint when there are no matches
echo "cleaned $1"
