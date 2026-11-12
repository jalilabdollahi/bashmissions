#!/usr/bin/env bash
set -euo pipefail

version=${1:-}
if [[ ! $version =~ ^v?([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  echo "invalid version: $version" >&2
  exit 2
fi
tag="v${BASH_REMATCH[1]}"       # normalise: always exactly one leading v

# Guard 1: porcelain output is stable for scripts and empty when clean.
if [[ -n $(git status --porcelain) ]]; then
  echo "working tree is not clean" >&2
  exit 1
fi

# Guard 2: --verify -q is silent and answers only through its exit status.
if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
  echo "tag $tag already exists" >&2
  exit 1
fi

git tag -a "$tag" -m "Release $tag"

if ! git push origin "$tag"; then
  echo "push failed: tag $tag exists locally, remove it with: git tag -d $tag" >&2
  exit 1
fi

echo "released $tag"
