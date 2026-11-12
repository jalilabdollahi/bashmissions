#!/usr/bin/env bash
set -euo pipefail

dry=0
if [[ ${1:-} == "-n" ]]; then
  dry=1
  shift
fi
if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh [-n] HOSTFILE LOCALFILE REMOTEPATH" >&2
  exit 2
fi
hostfile=$1 local_file=$2 remote_path=$3

if [[ ! -r $local_file ]]; then
  echo "cannot read $local_file" >&2
  exit 1
fi
if [[ ! -s $local_file ]]; then            # -s: exists AND has size > 0
  echo "refusing to push empty file: $local_file" >&2
  exit 1
fi

total=0 pushed=0
while IFS= read -r host; do
  [[ -z $host || $host == \#* ]] && continue
  total=$(( total + 1 ))
  if (( dry )); then
    echo "would push $local_file to $host:$remote_path"
  elif scp -q -o BatchMode=yes "$local_file" "$host:$remote_path"; then
    echo "pushed $host"
    pushed=$(( pushed + 1 ))
  else
    echo "FAILED $host"
  fi
done < "$hostfile"

if (( dry )); then
  echo "dry run: $total hosts, nothing copied"
else
  echo "pushed $pushed of $total"
  (( pushed == total ))
fi
