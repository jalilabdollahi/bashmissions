#!/usr/bin/env bash
set -euo pipefail

if (( $# != 3 )); then
  echo "usage: solution.sh FILE SECTION KEY" >&2
  exit 2
fi
file=$1 section=$2 wanted=$3
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 2
fi

trim() {
  local s=$1
  s=${s#"${s%%[![:space:]]*}"}
  s=${s%"${s##*[![:space:]]}"}
  printf '%s' "$s"
}

inside=0      # are we in the wanted section right now?
found=0
result=

while IFS= read -r line || [[ -n $line ]]; do
  line=$(trim "$line")
  [[ -z $line || $line == \#* || $line == \;* ]] && continue

  if [[ $line =~ ^\[(.*)\]$ ]]; then
    # A header flips the state; the section name is exactly what is in the brackets.
    if [[ ${BASH_REMATCH[1]} == "$section" ]]; then inside=1; else inside=0; fi
    continue
  fi

  if (( inside )) && [[ $line == *=* ]]; then
    key=$(trim "${line%%=*}")          # up to the first "="
    value=$(trim "${line#*=}")         # after the first "="
    if [[ $key == "$wanted" ]]; then
      found=1
      result=$value                    # keep going: the last definition wins
    fi
  fi
done < "$file"

if (( ! found )); then
  echo "missing key $wanted in [$section]" >&2
  exit 1
fi
echo "$result"
