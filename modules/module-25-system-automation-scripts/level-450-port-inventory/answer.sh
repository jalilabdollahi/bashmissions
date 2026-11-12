#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh HOSTFILE EXPECTED" >&2
  exit 2
fi
hostfile=$1 expected_file=$2
for f in "$hostfile" "$expected_file"; do
  if [[ ! -r $f ]]; then
    echo "cannot read $f" >&2
    exit 1
  fi
done

# host -> " 22 80 443 " (padded with spaces so "80" never matches inside "8080")
declare -A expected=()
while read -r host ports; do
  [[ -z $host || $host == \#* ]] && continue
  expected[$host]=" $ports "
done < "$expected_file"

scan_ports=(22 25 80 443 3306 5432)
hosts=0 deviations=0

while IFS= read -r host; do
  [[ -z $host || $host == \#* ]] && continue
  hosts=$(( hosts + 1 ))
  want=${expected[$host]:-${expected[default]:-" "}}

  open_list=""
  notes=()
  for port in "${scan_ports[@]}"; do
    if nc -z -w 1 "$host" "$port" 2>/dev/null; then
      open_list+=${open_list:+,}$port
      [[ $want == *" $port "* ]] || notes+=("  UNEXPECTED $port")
    else
      [[ $want == *" $port "* ]] && notes+=("  NOT-LISTENING $port")
    fi
  done

  echo "$host: open=${open_list:--}"
  for note in "${notes[@]+"${notes[@]}"}"; do
    echo "$note"
  done
  deviations=$(( deviations + ${#notes[@]} ))
done < "$hostfile"

echo "scanned $hosts hosts, $deviations deviations"
(( deviations == 0 ))
