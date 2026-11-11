#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: solution.sh regex|literal PATTERN" >&2
  exit 2
}
[[ $# -eq 2 ]] || usage
mode=$1
pattern=$2
[[ $mode == regex || $mode == literal ]] || usage

while IFS= read -r line || [[ -n $line ]]; do
  if [[ $mode == regex ]]; then
    # Unquoted variable on the right of =~: its contents are read as a regex.
    if [[ $line =~ $pattern ]]; then
      echo "$line"
    fi
  else
    # Quoted on purpose: Bash escapes every character, so . [ ] ( ) are just text.
    if [[ $line =~ "$pattern" ]]; then
      echo "$line"
    fi
  fi
done
