#!/usr/bin/env bash
set -euo pipefail

stages=(dev staging prod)
usage="usage: solution.sh FROM TO   (environments: dev staging prod)"

# index_of NAME -> prints its position in $stages, or fails.
index_of() {
  local i
  for i in "${!stages[@]}"; do
    [[ ${stages[i]} == "$1" ]] && { echo "$i"; return 0; }
  done
  return 1
}

# version_gt A B -> success when A is a newer version than B (numbers, not text).
version_gt() {
  local a1 a2 a3 b1 b2 b3
  IFS=. read -r a1 a2 a3 <<< "$1"
  IFS=. read -r b1 b2 b3 <<< "$2"
  (( a1 != b1 )) && { (( a1 > b1 )); return; }
  (( a2 != b2 )) && { (( a2 > b2 )); return; }
  (( a3 > b3 ))
}

from=${1:-} to=${2:-}
if ! from_i=$(index_of "$from") || ! to_i=$(index_of "$to"); then
  echo "$usage" >&2
  exit 2
fi
if (( to_i != from_i + 1 )); then
  echo "cannot promote $from to $to" >&2
  exit 2
fi

semver='^[0-9]+\.[0-9]+\.[0-9]+$'
version=""
[[ -r versions/$from ]] && version=$(<"versions/$from")
if [[ ! $version =~ $semver ]]; then
  echo "nothing deployable in $from" >&2
  exit 1
fi

current=""
[[ -r versions/$to ]] && current=$(<"versions/$to")

if [[ $current == "$version" ]]; then
  echo "$to already runs $version"
  exit 0
fi
if [[ $current =~ $semver ]] && version_gt "$current" "$version"; then
  echo "refusing to downgrade $to from $current to $version" >&2
  exit 1
fi
if [[ $to == prod && ! -f approvals/$version ]]; then
  echo "$version is not approved for prod" >&2
  exit 1
fi

if ! deployctl deploy --env "$to" --version "$version"; then
  echo "deploy to $to failed" >&2
  exit 1
fi

# Record the new state only now, and replace the file in one step.
mkdir -p versions
printf '%s\n' "$version" > "versions/$to.tmp"
mv "versions/$to.tmp" "versions/$to"
echo "promoted $version: $from -> $to"
