#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh FILE" >&2
  exit 2
fi
file=$1
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi

# keyword (lowercase) -> value (lowercase); only the first occurrence is stored.
declare -A seen=()
while IFS= read -r line; do
  # Trim, skip blanks and comments.
  line=${line#"${line%%[![:space:]]*}"}
  [[ -z $line || $line == \#* ]] && continue
  # "Key value", "Key=value" and "Key = value" all become "key value".
  line=${line//=/ }
  read -r key value _ <<< "$line"
  key=${key,,}
  [[ $key == match ]] && break           # the rest is conditional, not global
  [[ -n ${seen[$key]+set} ]] && continue # first one wins
  seen[$key]=${value,,}
done < "$file"

failed=0
check() {   # check Keyword default want-kind
  local name=$1 def=$2 kind=$3
  local key=${name,,} value suffix want ok=0 isdef=0
  if [[ -n ${seen[$key]+set} ]]; then
    value=${seen[$key]}
  else
    value=$def
    isdef=1
  fi
  if [[ $kind == no ]]; then
    want="no"
    [[ $value == no ]] && ok=1
  else
    want="<=4"
    [[ $value =~ ^[0-9]+$ ]] && (( value <= 4 )) && ok=1
  fi
  if (( ok )); then
    suffix=""; (( isdef )) && suffix=" (default)"
    echo "PASS $name=$value$suffix"
  else
    if (( isdef )); then suffix=" (default, want $want)"; else suffix=" (want $want)"; fi
    echo "FAIL $name=$value$suffix"
    failed=$(( failed + 1 ))
  fi
}

check PermitRootLogin        prohibit-password no
check PasswordAuthentication yes               no
check PermitEmptyPasswords   no                no
check X11Forwarding          no                no
check MaxAuthTries           6                 num

if (( failed == 0 )); then
  echo "hardening: all 5 checks passed"
else
  echo "hardening: $failed of 5 checks failed"
  exit 1
fi
