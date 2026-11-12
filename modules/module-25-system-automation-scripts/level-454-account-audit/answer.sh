#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh PASSWD SHADOW" >&2
  exit 2
fi
passwd=$1 shadow=$2
for f in "$passwd" "$shadow"; do
  if [[ ! -r $f ]]; then
    echo "cannot read $f" >&2
    exit 1
  fi
done

# name -> hash for every shadow entry (the key's presence matters, even if the hash is empty)
declare -A hash=()
while IFS=: read -r name pw _; do
  [[ -z $name || $name == \#* ]] && continue
  hash[$name]=$pw
done < "$shadow"

malformed=() extra_root=() service=() empty=() noshadow=()
declare -A uid_names=()
uid_order=()
accounts=0
lineno=0

while IFS= read -r line || [[ -n $line ]]; do
  lineno=$(( lineno + 1 ))
  [[ -z $line || $line == \#* ]] && continue

  # Count the colons: a valid passwd line has exactly six.
  colons=${line//[^:]/}
  if (( ${#colons} != 6 )); then
    malformed+=("MALFORMED line $lineno")
    continue
  fi
  IFS=: read -r name _ uid _ _ _ shell <<< "$line"
  accounts=$(( accounts + 1 ))

  if (( uid == 0 )) && [[ $name != root ]]; then
    extra_root+=("EXTRA-ROOT $name")
  fi
  if [[ -z ${uid_names[$uid]+set} ]]; then
    uid_order+=("$uid")
    uid_names[$uid]=$name
  else
    uid_names[$uid]+=" $name"
  fi
  if (( uid >= 1 && uid <= 999 )); then
    case ${shell##*/} in
      sh|bash|dash|zsh|ksh) service+=("SERVICE-SHELL $name $shell") ;;
    esac
  fi
  if [[ -z ${hash[$name]+set} ]]; then
    noshadow+=("NO-SHADOW $name")
  elif [[ -z ${hash[$name]} ]]; then
    empty+=("EMPTY-PASSWORD $name")
  fi
done < "$passwd"

dups=()
for uid in "${uid_order[@]+"${uid_order[@]}"}"; do
  [[ ${uid_names[$uid]} == *" "* ]] && dups+=("DUP-UID $uid ${uid_names[$uid]}")
done

findings=0
for group in malformed extra_root dups service empty noshadow; do
  declare -n list=$group
  for msg in "${list[@]+"${list[@]}"}"; do
    echo "$msg"
    findings=$(( findings + 1 ))
  done
  unset -n list
done

echo "audited $accounts accounts, $findings findings"
(( findings == 0 ))
