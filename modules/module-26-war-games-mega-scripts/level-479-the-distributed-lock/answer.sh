#!/usr/bin/env bash
# Directory-based lock with owner and expiry. mkdir is the atomic test-and-set.
set -euo pipefail

usage() {
  echo "usage: solution.sh acquire LOCK OWNER TTL NOW | release LOCK OWNER | status LOCK NOW" >&2
  exit 2
}

is_posint() { [[ $1 =~ ^[1-9][0-9]*$ ]]; }

# load_holder LOCK -> sets holder and expires; returns 1 if the metadata is
# missing or damaged (someone may be halfway through acquiring).
load_holder() {
  local lock=$1
  holder=unknown
  expires=
  [[ -r $lock/owner ]] && holder=$(< "$lock/owner")
  [[ -r $lock/expires ]] && expires=$(< "$lock/expires")
  [[ -r $lock/owner && $expires =~ ^[0-9]+$ ]]
}

write_meta() {
  local lock=$1 owner=$2 until=$3
  printf '%s\n' "$owner" > "$lock/owner"
  printf '%s\n' "$until" > "$lock/expires"
}

remove_lock() {
  rm -f "$1/owner" "$1/expires"
  rmdir "$1"
}

acquire() {
  local lock=$1 owner=$2 ttl=$3 now=$4 until
  until=$((now + ttl))
  if mkdir "$lock" 2>/dev/null; then
    # If writing the files fails, do not leave an empty lock behind.
    write_meta "$lock" "$owner" "$until" || { remove_lock "$lock"; exit 2; }
    echo "acquired $lock by $owner until $until"
    return 0
  fi
  if [[ ! -d $lock ]]; then
    echo "cannot create $lock" >&2
    exit 2
  fi
  if ! load_holder "$lock"; then
    echo "busy: $lock held by unknown" >&2
    exit 1
  fi
  if (( expires > now )); then
    if [[ $holder == "$owner" ]]; then
      write_meta "$lock" "$owner" "$until"
      echo "renewed $lock by $owner until $until"
      return 0
    fi
    echo "busy: $lock held by $holder for another $((expires - now)) s" >&2
    exit 1
  fi
  echo "reclaimed stale lock of $holder"
  remove_lock "$lock"
  # Someone faster may re-create it between our remove and mkdir: then we lose.
  if ! mkdir "$lock" 2>/dev/null; then
    echo "busy: $lock held by unknown" >&2
    exit 1
  fi
  write_meta "$lock" "$owner" "$until"
  echo "acquired $lock by $owner until $until"
}

release() {
  local lock=$1 owner=$2
  if [[ ! -d $lock ]]; then
    echo "not locked: $lock" >&2
    exit 1
  fi
  load_holder "$lock" || true
  if [[ $holder != "$owner" ]]; then
    echo "refused: $lock belongs to $holder, not $owner" >&2
    exit 3
  fi
  remove_lock "$lock"
  echo "released $lock"
}

status() {
  local lock=$1 now=$2
  if [[ ! -d $lock ]]; then
    echo free
  elif ! load_holder "$lock"; then
    echo "held by unknown, ? s left"
  elif (( expires > now )); then
    echo "held by $holder, $((expires - now)) s left"
  else
    echo "expired, was held by $holder"
  fi
}

[[ $# -ge 1 ]] || usage
case $1 in
  acquire)
    [[ $# -eq 5 ]] && is_posint "$4" && is_posint "$5" || usage
    acquire "$2" "$3" "$4" "$5"
    ;;
  release)
    [[ $# -eq 3 ]] || usage
    release "$2" "$3"
    ;;
  status)
    [[ $# -eq 3 ]] && is_posint "$3" || usage
    status "$2" "$3"
    ;;
  *) usage ;;
esac
