#!/usr/bin/env bash
set -euo pipefail

# --- helpers: one job each ---------------------------------------------------

# die CODE MESSAGE...  fatal error: message on stderr, exit with CODE
die() {
  local code=$1
  shift
  echo "error: $*" >&2
  exit "$code"
}

# log LEVEL MESSAGE...  progress lines go to stderr so stdout stays clean for results
log() {
  local level=$1
  shift
  echo "[$level] $*" >&2
}

# slugify TEXT  -> prints a URL-friendly name
slugify() {
  printf '%s' "$1" \
    | tr 'A-Z' 'a-z' \
    | tr -cs 'a-z0-9' '-' \
    | sed -E 's/^-+//; s/-+$//'
}

# valid_quota VALUE  -> status 0 when VALUE is a whole number 1..500
valid_quota() {
  [[ $1 =~ ^[0-9]+$ ]] && (( $1 >= 1 && $1 <= 500 ))
}

# tier_for GB  -> small, medium or large
tier_for() {
  if (( $1 <= 50 )); then
    echo small
  elif (( $1 <= 200 )); then
    echo medium
  else
    echo large
  fi
}

# --- the plan ----------------------------------------------------------------

[[ $# -ge 2 ]] || die 2 "usage: solution.sh NAME GB"

slug=$(slugify "$1")
[[ -n $slug ]] || die 3 "name has no usable characters"

if ! valid_quota "$2"; then
  die 4 "invalid quota: $2"
fi

tier=$(tier_for "$2")
log INFO "provisioning $slug"
log INFO "quota ${2}GB, tier $tier"
echo "home=/srv/customers/$slug"
