#!/usr/bin/env bash
set -euo pipefail

hook_lock()     { echo "locking $1"; }
hook_snapshot() { echo "snapshotting $1"; }
hook_notify()   { echo "telling #ops about $1"; }
hook_cache()    { echo "warming cache for $1"; }

before_hooks=()
after_hooks=()

# Registration only records function *names*; nothing runs yet.
register() {
  local spec=$1 phase name
  phase=${spec%%:*}
  name=${spec#*:}
  case $name in lock|snapshot|notify|cache) ;; *) name= ;; esac
  if [[ $spec != *:* || -z $name ]]; then
    echo "bad hook spec: $spec" >&2
    exit 2
  fi
  case $phase in
    before) before_hooks+=("hook_$name") ;;
    after)  after_hooks+=("hook_$name") ;;
    *) echo "bad hook spec: $spec" >&2; exit 2 ;;
  esac
}

deploy() {
  local h
  for h in "${before_hooks[@]}"; do "$h" "$1"; done
  echo "deploying $1"
  for h in "${after_hooks[@]}"; do "$h" "$1"; done
}

site=$1
shift
for spec in "$@"; do
  register "$spec"
done

deploy "$site"
