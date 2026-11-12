#!/usr/bin/env bash
set -euo pipefail

# "|| [[ -n $name ]]" also processes a final line that has no trailing newline.
while IFS= read -r name || [[ -n $name ]]; do
  # '%%' removes the LONGEST suffix matching ".*": from the first dot to the end.
  # With a single '%' only the last label (".example") would go.
  short=${name%%.*}
  echo "$name  =>  $short"
done
