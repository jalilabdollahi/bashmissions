#!/usr/bin/env bash
# Settings checker. Argument 1: file of key=value lines. The other arguments
# are keys to check. For each print "<key>: <value>", "<key>: (empty)" or
# "<key>: (not set)". An EMPTY value is different from a MISSING key.
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh FILE [KEY...]" >&2
  exit 2
fi
file=$1
shift

declare -A settings
while IFS= read -r line || [[ -n $line ]]; do
  [[ -z $line || $line == \#* || $line != *=* ]] && continue
  settings[${line%%=*}]=${line#*=}
done < "$file"

for key in "$@"; do
  # TODO: three cases. Which test tells "exists" apart from "empty"?
  echo "$key: ${settings[$key]:-(not set)}"
done
