#!/usr/bin/env bash
# Pull the text of the msg="..." field out of each log line on stdin.
# Print "msg: <text>" or "no msg". The text ends at the quote that closes msg,
# even when more quoted fields follow later in the line.
# TODO: a regex with one capture group; a ".*" will run on to the LAST quote, so
# TODO: describe the text as "any characters except a quote" instead
while IFS= read -r line || [[ -n $line ]]; do
  re='msg="(.*)"'
  if [[ $line =~ $re ]]; then
    echo "msg: ${BASH_REMATCH[1]}"
  else
    echo "no msg"
  fi
done
