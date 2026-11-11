#!/usr/bin/env bash
set -eE    # -E: functions, command substitutions and subshells inherit the ERR trap

publish() {
  healthcheck "$1"
  echo "healthy: $1"
  restart-site "$1"
  echo "restarted: $1"
}

# Single quotes: nothing is expanded until the trap fires. $? must be read
# first; any command in the handler would overwrite it. After the handler,
# set -e ends the script with the failing command's status.
trap 'status=$?; echo "failed: $BASH_COMMAND (status $status) at line $LINENO" >&2' ERR

publish "$1"
