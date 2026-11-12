#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh ACTION..." >&2
  exit 2
fi

verbose=off
steps=0

on_usr1() {
  if [[ $verbose == off ]]; then verbose=on; else verbose=off; fi
  echo "verbose is now $verbose"
}

on_usr2() {
  echo "status: $steps steps, verbose=$verbose"
}

# A trap runs in the main shell, so the handlers can change $verbose.
trap on_usr1 USR1
trap on_usr2 USR2

for action in "$@"; do
  case $action in
    go)
      steps=$((steps + 1))
      if [[ $verbose == on ]]; then
        echo "step $steps"
      fi
      ;;
    verbose)
      # $$ is the PID of this very script. kill is a builtin, so the signal
      # is delivered and the handler runs before the next command.
      kill -USR1 $$
      ;;
    status)
      kill -USR2 $$
      ;;
    *)
      echo "unknown command: $action" >&2
      exit 2
      ;;
  esac
done
