#!/usr/bin/env bash
# Invoice date checker. For each line on stdin print one of
#   "<date>: ok" | "<date>: bad format" | "<date>: bad month" | "<date>: bad day"
# TODO: regex ^YYYY-MM-DD$ with three ( ) groups  -> else "bad format"
# TODO: month must be 1..12 -> else "bad month"
# TODO: day must be 1..(days in that month, leap years for February) -> else "bad day"
while IFS= read -r entry || [[ -n $entry ]]; do
  echo "$entry: ok"
done
