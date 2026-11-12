#!/usr/bin/env bash
set -euo pipefail

if (( $# != 2 )); then
  echo "usage: solution.sh OLD_FILE NEW_FILE" >&2
  exit 2
fi
for f in "$1" "$2"; do
  if [[ ! -r $f ]]; then
    echo "cannot read $f" >&2
    exit 2
  fi
done

trim() {
  local s=$1
  s=${s#"${s%%[![:space:]]*}"}
  s=${s%"${s##*[![:space:]]}"}
  printf '%s' "$s"
}

# load FILE ARRAYNAME: fill the associative array called ARRAYNAME.
# "local -n" makes $2's name an alias, so one function can fill either array.
load() {
  local file=$1 key val
  local -n target=$2
  while IFS='=' read -r key val || [[ -n $key ]]; do
    key=$(trim "$key")
    val=$(trim "${val:-}")
    [[ -n $key && $key != \#* ]] || continue
    target[$key]=$val                      # the last line wins
  done < "$file"
}

declare -A old new
load "$1" old
load "$2" new

# An empty value would be invisible in the report.
show() { if [[ -z $1 ]]; then printf "''"; else printf '%s' "$1"; fi; }

added=0 removed=0 changed=0

# sort -u merges the two key lists; the blank line printf makes for an empty
# array is skipped inside the loop.
while IFS= read -r key; do
  [[ -n $key ]] || continue
  if [[ -z ${old[$key]+set} ]]; then
    echo "+ $key=$(show "${new[$key]}")"
    added=$(( added + 1 ))
  elif [[ -z ${new[$key]+set} ]]; then
    echo "- $key=$(show "${old[$key]}")"
    removed=$(( removed + 1 ))
  elif [[ ${old[$key]} != "${new[$key]}" ]]; then
    echo "~ $key: $(show "${old[$key]}") -> $(show "${new[$key]}")"
    changed=$(( changed + 1 ))
  fi
done < <(printf '%s\n' "${!old[@]}" "${!new[@]}" | sort -u)

if (( added + removed + changed == 0 )); then
  echo "no differences"
  exit 0
fi
echo "summary: $added added, $removed removed, $changed changed"
exit 1
