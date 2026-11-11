#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r path || [[ -n $path ]]; do
  # "/#" anchors the match to the START of the value.
  path=${path/#\/var\/log\/legacy\//\/var\/log\/lanternfish\/}
  # "/%" anchors the match to the END of the value.
  path=${path/%.log/.log.gz}
  echo "$path"
done
