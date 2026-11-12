#!/usr/bin/env bash
set -euo pipefail

name=${1:-} version=${2:-}
if [[ ! $name =~ ^[a-z0-9-]+$ || ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "usage: solution.sh NAME VERSION" >&2
  exit 2
fi

prefix="$name-$version-"

# An unmatched glob stays as the literal text "dist/*.tar", so test for it.
shopt -s nullglob
tars=(dist/*.tar)
if (( ${#tars[@]} == 0 )); then
  echo "no artifacts in dist/" >&2
  exit 1
fi

for path in "${tars[@]}"; do
  base=${path##*/}
  [[ $base == "$prefix"* ]] && continue      # already renamed on an earlier run
  mv "$path" "dist/$prefix$base"
done

# cksum prints "CRC SIZE NAME". Running it inside dist/ keeps the directory out of NAME,
# and the glob expands in sorted order. Build the file aside, then move it into place.
count=0
(
  cd dist
  cksum "$prefix"*.tar > MANIFEST.tmp
  mv MANIFEST.tmp MANIFEST.txt
)
count=$(grep -c . dist/MANIFEST.txt)
echo "wrote dist/MANIFEST.txt ($count artifact(s))"
