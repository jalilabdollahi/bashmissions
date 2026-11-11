#!/usr/bin/env bash
set -euo pipefail
# lf: one front door for status, restart, backup and hosts.
# Called as: solution.sh COMMAND [HOST]. Look COMMAND up in a table, call its function.

# TODO 1: write cmd_status, cmd_restart, cmd_backup, cmd_hosts (see the objective for their output).
# TODO 2: declare -A a table mapping each command name to its function name.
# TODO 3: no COMMAND -> usage on stderr, exit 2.
# TODO 4: unknown COMMAND -> message on stderr, exit 2. Otherwise call the function with the remaining arguments.
