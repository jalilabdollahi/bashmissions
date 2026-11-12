#!/usr/bin/env bash
if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh FILE..." >&2
  exit 2
fi

hit=""
for file in "$@"; do
  # A missing file makes grep fail too, so it is skipped without extra code.
  # -q: print nothing, the exit status alone answers "is there a match?".
  if grep -q -E '^PermitRootLogin[[:space:]]+yes' "$file" 2>/dev/null; then
    hit=$file
    break          # no need to read the rest of the files
  fi
done

if [[ -n $hit ]]; then
  echo "first insecure config: $hit"
else
  echo "no insecure config found"
  exit 1
fi
