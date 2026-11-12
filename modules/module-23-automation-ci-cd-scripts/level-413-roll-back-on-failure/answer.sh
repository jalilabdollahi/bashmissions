#!/usr/bin/env bash
set -euo pipefail

version=${1:-}
release="releases/$version"

if [[ -z $version || ! -d $release ]]; then
  echo "no such release: $version" >&2
  exit 2
fi

# Remember the old target first. On a first deploy there is no link at all.
previous=""
if [[ -L current ]]; then
  previous=$(readlink current)
fi

if [[ $previous == "$release" ]]; then
  echo "already on $version"
  exit 0
fi

# -s symbolic, -f replace an existing link, -n treat an existing link to a
# directory as a plain file (without it, ln would create the new link INSIDE
# the old release's directory).
ln -sfn "$release" current

rc=0
smoke-test || rc=$?

if (( rc == 0 )); then
  echo "deployed $version"
  echo "current -> $release"
  exit 0
fi

echo "smoke test failed for $version" >&2
if [[ -n $previous ]]; then
  ln -sfn "$previous" current
  echo "rolled back to ${previous#releases/}"
  echo "current -> $previous"
else
  rm -f current
  echo "no previous release to roll back to" >&2
fi
exit 1
