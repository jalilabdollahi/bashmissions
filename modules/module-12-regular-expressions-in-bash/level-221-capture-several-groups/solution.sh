#!/usr/bin/env bash
# Release tags on stdin, e.g. v2.14.3. Print "major=2 minor=14 patch=3" for valid
# tags and "bad tag: <line>" for anything else.
# TODO: one anchored regex with THREE ( ) groups, for major, minor and patch
# TODO: read them from BASH_REMATCH[1], [2] and [3] inside the matching branch
while IFS= read -r tag || [[ -n $tag ]]; do
  echo "bad tag: $tag"
done
