#!/usr/bin/env bash
set -euo pipefail

cmd_status()  { echo "$1: running"; }
cmd_restart() { echo "restarting $1"; }
cmd_backup()  { echo "backup of $1 queued"; }
cmd_hosts()   { printf '%s\n' anchovy barracuda cuttlefish; }

# The table: command name -> function name. A new command is one new line here
# (plus its function); the dispatcher below never changes.
declare -A commands=(
  [status]=cmd_status
  [restart]=cmd_restart
  [backup]=cmd_backup
  [hosts]=cmd_hosts
)

if (( $# == 0 )); then
  echo "usage: lf COMMAND [HOST]" >&2
  exit 2
fi

name=$1
shift

# ${commands[$name]:-} is empty for a missing key (a plain ${commands[$name]}
# would abort under set -u).
fn=${commands[$name]:-}
if [[ -z $fn ]]; then
  echo "lf: unknown command '$name'" >&2
  exit 2
fi

"$fn" "$@"
