#!/usr/bin/env bash
recipient=$1
file=$2

if [[ ! -r $file ]]; then
  echo "message file not found: $file" >&2
  exit 1
fi

# "<" makes the shell open the file and hand it to lantern-mail as fd 0.
# The tool just reads "its input", as if someone had typed the file.
lantern-mail "$recipient" < "$file"
