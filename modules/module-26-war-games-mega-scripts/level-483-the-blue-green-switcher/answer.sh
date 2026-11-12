#!/usr/bin/env bash
# Blue-green release switcher. `current` is a symlink; switching = replacing it
# atomically. Works with BSD and GNU userlands.
set -euo pipefail

usage() {
  echo "usage: solution.sh ROOT status | switch | rollback" >&2
  exit 2
}

[[ $# -eq 2 ]] || usage
root=$1
mode=$2
case $mode in status|switch|rollback) ;; *) usage ;; esac

tmplink=$root/.current.tmp
tmpfile=
cleanup() { rm -f "$tmplink" ${tmpfile:+"$tmpfile"}; }
trap cleanup EXIT

die() { echo "$*" >&2; exit 1; }

# live_slot: sets $live from the link target; dies unless it names a real slot.
live_slot() {
  local out target
  if [[ -L $root/current ]]; then
    out=$(ls -ld "$root/current")
    target=${out##* -> }
    case $target in
      releases/blue)  live=blue ;;
      releases/green) live=green ;;
      *) live= ;;
    esac
  else
    live=
  fi
  if [[ -z $live || ! -d $root/releases/$live ]]; then
    die "current is not a valid release link"
  fi
  if [[ $live == blue ]]; then idle=green; else idle=blue; fi
}

# version SLOT -> the VERSION text, or "none" when missing/empty.
version() {
  local f=$root/releases/$1/VERSION v=
  [[ -r $f ]] && v=$(< "$f")
  printf '%s' "${v:-none}"
}

# point_current SLOT: build the new link beside `current`, then rename it over.
# Plain `mv -f new current` would move the link INTO the directory that
# `current` points to, so the destination must be treated as a file:
# GNU mv spells that -T, BSD/macOS mv spells it -h.
point_current() {
  ln -sfn "releases/$1" "$tmplink"
  if mv -fT "$tmplink" "$root/current" 2>/dev/null; then
    return 0
  fi
  mv -fh "$tmplink" "$root/current"
}

# write_previous SLOT: plain file, so a normal write-then-rename is enough.
write_previous() {
  tmpfile=$root/previous.tmp
  printf '%s\n' "$1" > "$tmpfile"
  mv -f "$tmpfile" "$root/previous"
  tmpfile=
}

live_slot
case $mode in
  status)
    echo "live: $live ($(version "$live"))"
    echo "idle: $idle ($(version "$idle"))"
    ;;
  switch)
    new=$(version "$idle")
    old=$(version "$live")
    [[ $new != none ]] || die "idle slot $idle has no VERSION"
    [[ $new != "$old" ]] || die "nothing to switch: both slots run $new"
    if ! smoke-test "$root/releases/$idle" > /dev/null; then
      die "smoke test failed for $idle, staying on $live"
    fi
    point_current "$idle"
    write_previous "$live"
    echo "switch $live->$idle $new" >> "$root/switch.log"
    echo "switched: $live -> $idle ($new)"
    ;;
  rollback)
    back=
    [[ -r $root/previous ]] && back=$(< "$root/previous")
    if [[ -z $back || $back == "$live" || ! -d $root/releases/$back ]]; then
      die "nothing to roll back to"
    fi
    point_current "$back"
    write_previous "$live"
    echo "rollback $live->$back $(version "$back")" >> "$root/switch.log"
    echo "rolled back: $live -> $back ($(version "$back"))"
    ;;
esac
