#!/usr/bin/env bash
for f in "$1" "$2"; do
  if [[ ! -r $f ]]; then
    echo "cannot read: $f" >&2
    exit 1
  fi
done

# Door 3 stays open on the addresses; each "read -u 3" takes the next line.
exec 3< "$2"

while IFS= read -r name; do
  # read fails at end of file: then the variable is empty and we use a default.
  IFS= read -r -u 3 address || address="(none)"
  echo "$name -> $address"
done < "$1"

exec 3<&-
