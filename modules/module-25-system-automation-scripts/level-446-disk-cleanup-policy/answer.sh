#!/usr/bin/env bash
set -euo pipefail

dry=0
if [[ ${1:-} == "-n" ]]; then
  dry=1
  shift
fi
if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh [-n] POLICY DIR" >&2
  exit 2
fi
policy=$1
dir=$2
if [[ ! -r $policy ]]; then
  echo "cannot read $policy" >&2
  exit 1
fi
if [[ ! -d $dir ]]; then
  echo "no such directory: $dir" >&2
  exit 1
fi

# Pass 1: validate every rule before anything is deleted.
lineno=0
while IFS= read -r line; do
  lineno=$(( lineno + 1 ))
  [[ -z ${line//[[:space:]]/} || $line == \#* ]] && continue
  read -r pat days bytes extra <<< "$line"
  if [[ -z $bytes || -n $extra || ! $days =~ ^[0-9]+$ || ! $bytes =~ ^[0-9]+$ ]]; then
    echo "policy line $lineno: invalid rule: $line" >&2
    exit 1
  fi
done < "$policy"

# Pass 2: apply.
rule=0 count=0 freed=0
while IFS= read -r line; do
  [[ -z ${line//[[:space:]]/} || $line == \#* ]] && continue
  rule=$(( rule + 1 ))
  read -r pat days bytes <<< "$line"

  args=(-type f -name "$pat")            # quoted: find, not the shell, expands the wildcard
  (( days > 0 )) && args+=(-mtime +"$days")
  (( bytes > 0 )) && args+=(-size +"$bytes"c)

  while IFS= read -r path; do
    [[ -f $path ]] || continue            # already removed by an earlier rule
    size=$(( $(wc -c < "$path") ))        # arithmetic strips the padding some wc versions add
    if (( dry )); then
      echo "would delete $path (rule $rule)"
    else
      echo "delete $path (rule $rule)"
      rm -f -- "$path"
    fi
    count=$(( count + 1 ))
    freed=$(( freed + size ))
  done < <(find "$dir" "${args[@]}" | sort)
done < "$policy"

if (( dry )); then
  echo "would remove $count files, $freed bytes"
else
  echo "removed $count files, freed $freed bytes"
fi
