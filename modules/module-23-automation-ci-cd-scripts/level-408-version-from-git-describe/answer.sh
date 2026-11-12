#!/usr/bin/env bash
set -euo pipefail

# "if out=$(cmd); then" runs the command, keeps its output, and branches on
# its exit status, so set -e never gets a chance to end the script.
if out=$(git describe --tags --long --dirty --match 'v[0-9]*' 2>/dev/null); then
  :
else
  echo "version=0.0.0-dev+g$(git rev-parse --short HEAD)"
  exit 0
fi

# Anchored at the END: <tag>-<distance>-g<hash>[-dirty]. The leading (.+) is
# greedy, so hyphens inside the tag (v1.5.0-rc1) stay part of the tag.
re='^v(.+)-([0-9]+)-g([0-9a-f]+)(-dirty)?$'
if [[ ! $out =~ $re ]]; then
  echo "cannot parse describe output: $out" >&2
  exit 1
fi
tag=${BASH_REMATCH[1]}
distance=${BASH_REMATCH[2]}
hash=${BASH_REMATCH[3]}
dirty=${BASH_REMATCH[4]}

# The tag must itself start like a version number.
if [[ ! $tag =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
  echo "cannot parse describe output: $out" >&2
  exit 1
fi

if (( distance == 0 )) && [[ -z $dirty ]]; then
  echo "version=$tag"
else
  suffix=""
  [[ -n $dirty ]] && suffix=".dirty"
  echo "version=$tag-dev.$distance+g$hash$suffix"
fi
