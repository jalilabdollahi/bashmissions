#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1

# Check 1: an empty value must never reach rm. "$dir/" would become "/".
if [[ -z $dir ]]; then
  echo "refusing: empty path" >&2
  exit 2
fi
if [[ $dir == / ]]; then
  echo "refusing: that is the root folder" >&2
  exit 1
fi
if [[ ! -d $dir ]]; then
  echo "refusing: $dir is not a folder" >&2
  exit 1
fi

# Real, absolute locations: ".." and symlinks are gone after pwd -P.
base="$(pwd -P)/shared"
resolved=$(cd "$dir" && pwd -P)

if [[ $resolved == "$base" ]]; then
  echo "refusing: that is the shared folder itself" >&2
  exit 1
fi
# The trailing slashes make sure "shared-old" is not mistaken for "shared".
case "$resolved/" in
  "$base"/*) ;;
  *)
    echo "refusing: $dir is outside shared" >&2
    exit 1
    ;;
esac

rm -rf -- "$resolved"
echo "deleted: $dir"
