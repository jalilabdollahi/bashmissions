#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1
if [[ ! -d $dir ]]; then
  echo "no such directory: $dir" >&2
  exit 1
fi

row() { printf '%-10s %-17s %s\n' "$1" "$2" "$3"; }
row USER SCHEDULE COMMAND

jobs=0 users=0
for path in "$dir"/*; do          # "*" skips names that start with a dot
  [[ -f $path ]] || continue
  user=${path##*/}
  lineno=0
  found=0
  while IFS= read -r line || [[ -n $line ]]; do
    lineno=$(( lineno + 1 ))
    # Blank, comment and VAR=value lines are not jobs.
    [[ $line =~ ^[[:space:]]*(#.*)?$ ]] && continue
    [[ $line =~ ^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*= ]] && continue

    read -r first rest <<< "$line"
    if [[ $first == @* ]]; then
      schedule=$first
      command=$rest
    else
      read -r m h dom mon dow command <<< "$line"
      schedule="$m $h $dom $mon $dow"
    fi
    if [[ -z ${command:-} ]]; then
      echo "$user line $lineno: malformed entry" >&2
      continue
    fi
    row "$user" "$schedule" "$command"
    found=$(( found + 1 ))
  done < "$path"

  if (( found == 0 )); then
    row "$user" - "(no jobs)"
  else
    jobs=$(( jobs + found ))
    users=$(( users + 1 ))
  fi
done

echo "$jobs jobs across $users users"
