#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh HOSTFILE SERVICE" >&2
  exit 2
fi
hostfile=$1
service=$2
if [[ ! $service =~ ^[A-Za-z0-9@._-]+$ ]]; then
  echo "bad service name: $service" >&2
  exit 2
fi
if [[ ! -r $hostfile ]]; then
  echo "cannot read $hostfile" >&2
  exit 1
fi

# Load the list first: when something breaks we must know how many hosts remain.
hosts=()
while IFS= read -r line; do
  [[ -z $line || $line == \#* ]] && continue
  hosts+=("$line")
done < "$hostfile"

abort() {   # abort INDEX REASON
  local left=$(( ${#hosts[@]} - $1 - 1 ))
  echo "ABORT: ${hosts[$1]} $2; $left hosts left untouched" >&2
  exit 1
}

for i in "${!hosts[@]}"; do
  host=${hosts[i]}
  echo "restarting $host"
  ssh -n -o BatchMode=yes "$host" systemctl restart "$service" || abort "$i" "restart failed"

  state=unknown
  healthy=0
  for check in 1 2 3; do
    # is-active exits non-zero when not active, so keep set -e out of the way.
    state=$(ssh -n -o BatchMode=yes "$host" systemctl is-active "$service" 2>/dev/null) || true
    if [[ $state == active ]]; then
      echo "$host healthy after $check check(s)"
      healthy=1
      break
    fi
  done
  (( healthy )) || abort "$i" "did not recover (last state: $state)"
done

echo "rolling restart complete: ${#hosts[@]} hosts"
