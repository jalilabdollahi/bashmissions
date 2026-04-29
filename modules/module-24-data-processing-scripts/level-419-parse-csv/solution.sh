#!/usr/bin/env bash
set -euo pipefail
while IFS=, read -r name score; do
  [[ $name == name ]] && continue
  echo "$name=$score"
done < fixtures/data.csv
