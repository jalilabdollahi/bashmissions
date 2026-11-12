#!/usr/bin/env bash
set -euo pipefail

image=${1:-} version=${2:-} context=${3:-.}
re='^([0-9]+)\.([0-9]+)\.[0-9]+(-[0-9A-Za-z.]+)?$'
if [[ -z $image ]] || [[ ! $version =~ $re ]]; then
  echo "usage: solution.sh IMAGE VERSION [CONTEXT]" >&2
  exit 2
fi
major=${BASH_REMATCH[1]} minor=${BASH_REMATCH[2]} suffix=${BASH_REMATCH[3]}

# Build exactly once. Every other tag points at this same image.
if ! docker build --build-arg "VERSION=$version" -t "$image:$version" "$context"; then
  echo "build failed" >&2
  exit 1
fi

tags=("$version")
if [[ -z $suffix ]]; then
  # Only stable releases move the shared tags.
  docker tag "$image:$version" "$image:$major.$minor"
  docker tag "$image:$version" "$image:latest"
  tags+=("$major.$minor" latest)
fi

for tag in "${tags[@]}"; do
  if ! docker push "$image:$tag"; then
    echo "push failed: $image:$tag" >&2
    exit 1
  fi
  echo "pushed $image:$tag"
done
