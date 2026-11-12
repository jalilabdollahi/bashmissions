#!/usr/bin/env bash
set -euo pipefail

h_log()  { echo "log: $*"; }
h_mail() { echo "mail to ops: $*"; }
h_page() { echo "paging on-call: $*"; }

declare -A handlers=()     # event -> "fn1 fn2 ..." in registration order
problems=0

on() {
  local event=$1 fn=$2
  if ! declare -F "$fn" > /dev/null; then
    echo "on: no such handler '$fn'" >&2
    problems=1
    return 0
  fi
  handlers[$event]+="${handlers[$event]:+ }$fn"   # add a space only if non-empty
}

emit() {
  local event=$1 fn
  shift
  if [[ -z ${handlers[$event]:-} ]]; then
    echo "emit: nobody listens to '$event'" >&2
    problems=1
    return 0
  fi
  # Unquoted on purpose: the names are our own function names, split on spaces.
  # (The arguments stay quoted.)
  for fn in ${handlers[$event]}; do
    "$fn" "$@"
  done
}

while read -ra words; do
  (( ${#words[@]} > 0 )) || continue
  case ${words[0]} in
    on)   on "${words[1]:-}" "${words[2]:-}" ;;
    emit) emit "${words[1]:-}" "${words[@]:2}" ;;
    *)    echo "unknown command '${words[0]}'" >&2; problems=1 ;;
  esac
done

exit "$problems"
