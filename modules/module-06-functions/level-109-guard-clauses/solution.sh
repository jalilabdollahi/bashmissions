#!/usr/bin/env bash
# ./solution.sh NAME GB   set a disk quota, but refuse bad input early.
# TODO: set_quota NAME GB with three guard clauses (messages to stderr), each
#       followed by an immediate return, and the success line at the very end.
# TODO: call it with "${1:-}" "${2:-}" and exit with its status.
