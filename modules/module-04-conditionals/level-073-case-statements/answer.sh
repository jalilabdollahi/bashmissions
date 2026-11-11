#!/usr/bin/env bash
set -euo pipefail

action="${1:-}"

# case compares one word against a list of patterns, top to bottom.
# Each branch ends with ;; and the whole statement closes with esac.
case "$action" in
  start)
    echo "lanternd: starting"
    ;;
  stop)
    echo "lanternd: stopping"
    ;;
  restart)
    echo "lanternd: restarting"
    ;;
  status)
    echo "lanternd: running (pid 4242)"
    ;;
  *)
    # * matches anything, so it must be the last branch.
    echo "usage: solution.sh start|stop|restart|status" >&2
    exit 2
    ;;
esac
