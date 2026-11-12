#!/usr/bin/env bash
# Daily digest: print each server once, in order of first appearance,
# then "removed: N" with the number of repeats dropped.
# Plain arrays and loops only (no sort/uniq/awk/maps).
unique=()

for name in "$@"; do
  # TODO: skip this name if it is already in unique;
  #       otherwise append it
  unique+=("$name")
done

if (( ${#unique[@]} > 0 )); then
  printf '%s\n' "${unique[@]}"
fi
echo "removed: 0"
