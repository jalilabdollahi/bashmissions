#!/usr/bin/env bash
set -euo pipefail

declare -A value source

# Layer 1: defaults.
for pair in bind=127.0.0.1 log=info port=8080 workers=2; do
  value[${pair%%=*}]=${pair#*=}
  source[${pair%%=*}]=default
done

# Layer 2: the file.
if [[ -n ${1:-} ]]; then
  if [[ ! -r $1 ]]; then
    echo "cannot read $1" >&2
    exit 1
  fi
  while IFS='=' read -r key val || [[ -n $key ]]; do
    key=${key#"${key%%[![:space:]]*}"};   key=${key%"${key##*[![:space:]]}"}
    val=${val:-}
    val=${val#"${val%%[![:space:]]*}"};   val=${val%"${val##*[![:space:]]}"}
    if [[ $key =~ ^[a-z_][a-z0-9_]*$ && -n $val ]]; then
      value[$key]=$val
      source[$key]=file
    fi
  done < "$1"
fi

# Layer 3: environment. compgen -v prints the names of variables starting with LF_.
for var in $(compgen -v LF_ || true); do
  if [[ $var =~ ^LF_[A-Z0-9_]+$ && -n ${!var} ]]; then
    key=${var#LF_}
    key=${key,,}
    value[$key]=${!var}
    source[$key]=env
  fi
done

# Width of the longest name, so the equals signs line up.
width=0
for key in "${!value[@]}"; do
  (( ${#key} > width )) && width=${#key}
done

# Associative arrays have no order; sort the names ourselves.
while IFS= read -r key; do
  printf '%-*s = %s [%s]\n' "$width" "$key" "${value[$key]}" "${source[$key]}"
done < <(printf '%s\n' "${!value[@]}" | sort)
