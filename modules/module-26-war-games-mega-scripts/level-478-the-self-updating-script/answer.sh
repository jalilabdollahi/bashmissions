#!/usr/bin/env bash
# lantern: a tool that can update itself, carefully.
set -euo pipefail

VERSION=1.0.0
BASE=https://updates.lanternfish.example/lantern
self=$0

usage() {
  echo "usage: solution.sh version | update [--check] [--force] [--channel NAME] | rollback" >&2
  exit 2
}

# vercmp A B: prints -1, 0 or 1, comparing component by component as numbers.
vercmp() {
  local -a a b
  local i
  IFS=. read -ra a <<< "$1"
  IFS=. read -ra b <<< "$2"
  for i in 0 1 2; do
    if (( 10#${a[i]} < 10#${b[i]} )); then echo -1; return; fi
    if (( 10#${a[i]} > 10#${b[i]} )); then echo 1; return; fi
  done
  echo 0
}

cmd=${1:-}
[[ -n $cmd ]] || usage
shift

do_update() {
  local check=0 force=0 channel=stable latest rel work reported expected crc size want
  while (( $# > 0 )); do
    case $1 in
      --check) check=1; shift ;;
      --force) force=1; shift ;;
      --channel)
        [[ ${2:-} =~ ^[a-z]+$ ]] || usage
        channel=$2
        shift 2
        ;;
      *) usage ;;
    esac
  done
  work=$(mktemp -d)
  trap 'rm -rf "$work"' EXIT

  # 1. what does the server think is latest? It is untrusted input: validate it.
  if ! curl -sS --fail --max-time 10 -o "$work/VERSION" "$BASE/$channel/VERSION" 2> /dev/null; then
    echo "update check failed: cannot reach server" >&2
    exit 3
  fi
  latest=$(head -n 1 "$work/VERSION")
  if [[ ! $latest =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "update check failed: server sent a bad version '$latest'" >&2
    exit 3
  fi

  # 2. compare
  rel=$(vercmp "$VERSION" "$latest")
  if [[ $rel == 1 ]]; then
    echo "refusing to downgrade from $VERSION to $latest" >&2
    exit 4
  fi
  if [[ $rel == 0 && $force -eq 0 ]] || { [[ $rel == 0 ]] && (( check )); }; then
    echo "lantern $VERSION is up to date"
    exit 0
  fi
  if (( check )); then
    echo "update available: $VERSION -> $latest"
    exit 10
  fi

  # 3. download into the scratch directory
  if ! curl -sS --fail --max-time 10 -o "$work/new.sh" "$BASE/$channel/lantern-$latest.sh" 2> /dev/null ||
     ! curl -sS --fail --max-time 10 -o "$work/new.cksum" "$BASE/$channel/lantern-$latest.cksum" 2> /dev/null; then
    echo "update aborted: download failed" >&2
    exit 5
  fi

  # 4. verify: checksum, syntax, and what the script says about itself
  read -r crc size _ < <(cksum < "$work/new.sh")
  read -r want_crc want_size _ < "$work/new.cksum" || true
  if [[ $crc != "${want_crc:-}" || $size != "${want_size:-}" ]]; then
    echo "update aborted: checksum mismatch" >&2
    exit 5
  fi
  if ! bash -n "$work/new.sh" 2> /dev/null; then
    echo "update aborted: downloaded script has a syntax error" >&2
    exit 5
  fi
  reported=$(bash "$work/new.sh" version 2> /dev/null || true)
  expected="lantern $latest"
  if [[ $reported != "$expected" ]]; then
    echo "update aborted: downloaded script reports version ${reported#lantern }, expected $latest" >&2
    exit 5
  fi

  # 5. install: keep the old one, prepare the new one beside it, swap with one rename
  cp -p "$self" "$self.old"
  cp -p "$self" "$self.new"
  cat "$work/new.sh" > "$self.new"
  mv "$self.new" "$self"
  echo "updated lantern $VERSION -> $latest (previous kept as $self.old)"
  # The script that was running has been replaced. Leave before bash reads anything else from it.
  exit 0
}

do_rollback() {
  local old_version
  (( $# == 0 )) || usage
  if [[ ! -f $self.old ]]; then
    echo "error: no previous version to roll back to" >&2
    exit 3
  fi
  old_version=$(bash "$self.old" version 2> /dev/null || true)
  mv "$self.old" "$self"
  echo "rolled back to $old_version"
  exit 0
}

case $cmd in
  version) (( $# == 0 )) || usage; echo "lantern $VERSION" ;;
  update) do_update "$@" ;;
  rollback) do_rollback "$@" ;;
  *) usage ;;
esac
