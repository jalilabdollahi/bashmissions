#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh POLICY" >&2
  exit 2
fi
policy=$1
if [[ ! -r $policy ]]; then
  echo "cannot read $policy" >&2
  exit 1
fi

# name -> full version string
declare -A installed=()
while read -r name version; do
  installed[$name]=$version
done < <(dpkg-query -W -f='${Package} ${Version}\n')

# Validate the policy words first, so we never print a half report.
lineno=0
while read -r word _; do
  lineno=$(( lineno + 1 ))
  case $word in
    ''|\#*|require|forbid|minver) ;;
    *) echo "policy line $lineno: unknown rule '$word'" >&2; exit 1 ;;
  esac
done < "$policy"

# "1.9.5p2-3" -> "1.9.5": keep the leading run of digits and dots.
numeric() {
  local v=$1
  [[ $v =~ ^[0-9][0-9.]* ]] && echo "${BASH_REMATCH[0]%.}" || echo 0
}

# Returns success if $1 is older than $2 (both plain dotted numbers).
older() {
  local IFS=.
  local -a a=($1) b=($2)
  local n=${#a[@]} i x y
  (( ${#b[@]} > n )) && n=${#b[@]}
  for (( i = 0; i < n; i++ )); do
    x=$(( 10#${a[i]:-0} ))
    y=$(( 10#${b[i]:-0} ))
    (( x < y )) && return 0
    (( x > y )) && return 1
  done
  return 1
}

problems=0
while read -r word name want _; do
  case $word in
    require)
      if [[ -z ${installed[$name]:-} ]]; then echo "MISSING $name"; problems=$(( problems + 1 )); fi ;;
    forbid)
      if [[ -n ${installed[$name]:-} ]]; then
        echo "FORBIDDEN $name (installed ${installed[$name]})"
        problems=$(( problems + 1 ))
      fi ;;
    minver)
      if [[ -z ${installed[$name]:-} ]]; then
        echo "MISSING $name"; problems=$(( problems + 1 ))
      else
        have=$(numeric "${installed[$name]}")
        if older "$have" "$want"; then
          echo "OUTDATED $name $have < $want"
          problems=$(( problems + 1 ))
        fi
      fi ;;
  esac
done < <(grep -Ev '^[[:space:]]*(#|$)' "$policy" || true)

if (( problems == 0 )); then
  echo "audit: clean"
else
  echo "audit: $problems problem(s)"
  exit 1
fi
