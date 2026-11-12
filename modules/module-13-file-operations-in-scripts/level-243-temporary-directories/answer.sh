#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh SITE" >&2
  exit 2
fi
site=$1
if [[ ! -d $site ]]; then
  echo "no such folder: $site" >&2
  exit 1
fi

# A brand-new empty folder that nobody else knows about.
stage=$(mktemp -d)
# Registered right after creation; ${stage:?} makes rm refuse an empty name.
trap 'rm -rf "${stage:?}"' EXIT

shopt -s nullglob
count=0
for page in "$site"/*.html; do
  name=${page##*/}
  [[ $name == draft-* ]] && continue
  cp "$page" "$stage/$name"
  echo "$name" >> "$stage/MANIFEST"
  count=$(( count + 1 ))
done

if (( count == 0 )); then
  echo "no pages to pack in $site" >&2
  exit 1
fi

out="$PWD/release.tar"
# tar runs inside the stage, so the archive holds bare names.
( cd "$stage" && tar -cf "$out" -- * )

echo "packed $count pages into release.tar"
tar -tf release.tar | sort
