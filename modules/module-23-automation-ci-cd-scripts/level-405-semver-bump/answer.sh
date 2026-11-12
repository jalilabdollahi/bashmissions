#!/usr/bin/env bash
set -euo pipefail

usage="usage: solution.sh VERSION major|minor|patch"
if (( $# != 2 )); then
  echo "$usage" >&2
  exit 2
fi
version=$1 part=$2

case $part in
  major|minor|patch) ;;
  *) echo "$usage" >&2; exit 2 ;;
esac

# Each number is 0 or starts with 1-9, so "01" fails to match (and can never
# be misread as octal in the arithmetic below).
num='(0|[1-9][0-9]*)'
re="^(v?)$num\\.$num\\.$num\$"
if [[ ! $version =~ $re ]]; then
  echo "invalid version: $version" >&2
  exit 2
fi

prefix=${BASH_REMATCH[1]}
major=${BASH_REMATCH[2]}
minor=${BASH_REMATCH[3]}
patch=${BASH_REMATCH[4]}

case $part in
  major) major=$(( major + 1 )); minor=0; patch=0 ;;
  minor) minor=$(( minor + 1 )); patch=0 ;;
  patch) patch=$(( patch + 1 )) ;;
esac

echo "$prefix$major.$minor.$patch"
