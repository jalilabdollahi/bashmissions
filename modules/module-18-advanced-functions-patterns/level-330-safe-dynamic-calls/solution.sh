#!/usr/bin/env bash
set -euo pipefail
# Ops bot. Reads "ACTION TARGET" lines on stdin and calls do_ACTION TARGET,
# but only for actions on the allow-list: restart, reload, status.

do_restart() { echo "restarting $1"; }
do_reload()  { echo "reloading $1"; }
do_status()  { echo "$1 is up"; }
do_wipe()    { echo "wiping $1"; }

# TODO 1: keep the allowed action names in an array.
# TODO 2: read each line into action and target; skip blank lines.
# TODO 3: exact-match action against the array. Not found -> message on stderr, remember it, next line.
# TODO 4: found -> call "do_$action" "$target".
# TODO 5: exit 3 at the end if anything was refused.
