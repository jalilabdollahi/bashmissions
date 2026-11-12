#!/usr/bin/env bash
# Ollie's filter. Usage: solution.sh regex|literal PATTERN   (lines on stdin)
# Print the lines that match; "regex" mode uses PATTERN as a regex, "literal"
# mode as plain text. Right now neither mode behaves, and the reason is the quotes.
usage() {
  echo "usage: solution.sh regex|literal PATTERN" >&2
  exit 2
}
[[ $# -eq 2 ]] || usage
mode=$1
pattern=$2

while IFS= read -r line || [[ -n $line ]]; do
  if [[ $mode == regex ]]; then
    # TODO: this test treats the pattern as text; fix how it reaches =~
    if [[ $line =~ "$pattern" ]]; then
      echo "$line"
    fi
  elif [[ $mode == literal ]]; then
    # TODO: here the pattern really should be text; check what this line does
    if [[ $line =~ $pattern ]]; then
      echo "$line"
    fi
  else
    usage
  fi
done
