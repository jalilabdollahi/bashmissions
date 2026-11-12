#!/usr/bin/env bash
set -euo pipefail

dry=0
if [[ ${1:-} == "-n" ]]; then
  dry=1
  shift
fi
if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh [-n] USER STAMP" >&2
  exit 2
fi
user=$1
stamp=$2

# Field 3 of the passwd line is the UID. awk prints nothing if the user is absent.
uid=$(awk -F: -v u="$user" '$1 == u { print $3 }' fixtures/etc/passwd)
if [[ -z $uid ]]; then
  echo "unknown user: $user" >&2
  exit 1
fi
if (( uid < 1000 )); then
  echo "refusing to offboard system account $user" >&2
  exit 3
fi

home=fixtures/home/$user
archive=offboarded/$user-$stamp.tar.gz

if (( dry )); then
  echo "would lock $user"
  echo "would archive $home to $archive"
  exit 0
fi

# Step 1: close the door before anything else.
usermod -L -s /usr/sbin/nologin "$user"

# Step 2: keep the files.
files=0
shown=none
if [[ -d $home ]]; then
  mkdir -p offboarded
  tar -czf "$archive" -C fixtures/home "$user"
  files=$(tar -tzf "$archive" | grep -vc '/$' || true)
  shown=$archive
fi

# Step 3: the report.
echo "offboarded: $user"
echo "locked: yes"
echo "archive: $shown"
echo "files: $files"
