#!/usr/bin/env bash
# File classifier for the recovery stick: solution.sh PATH...
# Written with bash habits; rewrite it for #!/bin/sh (dash) without changing
# the output. Kinds: missing, directory, image, archive, log, other.
set -eu

if (( $# == 0 )); then
  echo "usage: solution.sh PATH..." >&2
  exit 2
fi

count=0
for path in "$@"; do
  lower=${path,,}
  if [[ ! -e $path ]]; then
    kind=missing
  elif [[ -d $path ]]; then
    kind=directory
  elif [[ $lower == *.png || $lower == *.jpg || $lower == *.jpeg || $lower == *.gif ]]; then
    kind=image
  elif [[ $lower == *.tar.gz || $lower == *.tgz || $lower == *.zip ]]; then
    kind=archive
  elif [[ $lower == *.log ]]; then
    kind=log
  else
    kind=other
  fi
  echo "$path: $kind"
  ((count++)) || true
done
echo "items: $count"
# TODO: use #!/bin/sh, [ ] tests, a case on the lower-cased name (use tr), and
# count=$((count + 1)). Test it with: sh solution.sh yourfile.PNG
