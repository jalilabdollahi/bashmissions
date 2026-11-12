#!/usr/bin/env bash
set -euo pipefail

dir=$1

if [[ ! -d $dir ]]; then
  echo "lf: plugin directory '$dir' not found" >&2
  exit 1
fi

# With nullglob an unmatched pattern expands to nothing instead of staying as
# the literal text "plugins/*.sh", so an empty folder gives an empty loop.
shopt -s nullglob

count=0
for file in "$dir"/*.sh; do
  name=${file##*/}      # strip the directory
  name=${name%.sh}      # strip the suffix
  source "$file"        # defines plugin_NAME in *this* shell
  echo "loaded $name"
  "plugin_$name"
  count=$(( count + 1 ))
done

if (( count == 0 )); then
  echo "no plugins found"
fi
