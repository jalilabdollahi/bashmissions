#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh HOST STAMP" >&2
  exit 2
fi
host=$1
stamp=$2
dir=incident-$stamp-$host

# Evidence is never overwritten.
if [[ -e $dir ]]; then
  echo "evidence folder already exists: $dir" >&2
  exit 1
fi
mkdir -m 700 "$dir"            # private: only the responder may read it

collected=0 failed=0

# collect FILE COMMAND...: run COMMAND on the host, save stdout+stderr into FILE.
collect() {
  local file=$dir/$1 rc=0
  shift
  ssh -n -o BatchMode=yes "$host" "$*" > "$file" 2>&1 || rc=$?
  if (( rc == 255 )); then
    # A dead host gives no evidence at all: do not leave an empty folder behind.
    rm -r "$dir"
    echo "cannot reach $host" >&2
    exit 1
  fi
  if (( rc != 0 )); then
    echo "ERROR: exit $rc" >> "$file"
    failed=$(( failed + 1 ))
  fi
  collected=$(( collected + 1 ))
}

collect uptime.txt uptime
collect df.txt df -P
collect ps.txt ps -ef
collect ss.txt ss -tan

# Facts about the collection itself.
{
  echo "host=$host"
  echo "stamp=$stamp"
  echo "collected_by=$USER"
} > "$dir/meta.txt"

# Manifest: cksum of every file, in name order, taken from inside the folder so
# the names are bare. Written last, and it does not list itself.
( cd "$dir" && cksum meta.txt df.txt ps.txt ss.txt uptime.txt | sort -k3,3 > MANIFEST )

echo "snapshot: $dir"
echo "collected: $collected files, $failed failed"
echo "manifest: $dir/MANIFEST"
