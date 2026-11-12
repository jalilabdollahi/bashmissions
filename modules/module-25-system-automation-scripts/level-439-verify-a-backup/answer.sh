#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1
manifest=$dir/MANIFEST
if [[ ! -f $manifest ]]; then
  echo "no manifest in $dir" >&2
  exit 1
fi

ok=0 failed=0 missing=0 unlisted=0
listed=" "   # names seen in the manifest, space separated, for the UNLISTED pass

while read -r crc size name; do
  [[ -n $name ]] || continue
  listed+="$name "
  if [[ ! -f $dir/$name ]]; then
    echo "MISSING $name"
    missing=$(( missing + 1 ))
    continue
  fi
  # Reading from stdin makes cksum print only "CRC SIZE", with no file name.
  actual=$(cksum < "$dir/$name")
  if [[ $actual == "$crc $size" ]]; then
    echo "OK $name"
    ok=$(( ok + 1 ))
  else
    echo "FAILED $name"
    failed=$(( failed + 1 ))
  fi
done < "$manifest"

for path in "$dir"/*; do
  [[ -f $path ]] || continue
  name=${path##*/}
  [[ $name == MANIFEST ]] && continue
  if [[ $listed != *" $name "* ]]; then
    echo "UNLISTED $name"
    unlisted=$(( unlisted + 1 ))
  fi
done

echo "verified: $ok ok, $failed failed, $missing missing, $unlisted unlisted"
(( failed == 0 && missing == 0 ))
