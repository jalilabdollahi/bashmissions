#!/usr/bin/env bash
set -e
# Restart job for one customer site ($1). When a step fails it should leave
# behind: the command, its exit status and the line in this file.

publish() {
  healthcheck "$1"
  echo "healthy: $1"
  restart-site "$1"
  echo "restarted: $1"
}

# TODO 1: change the options so the ERR trap is inherited by functions.
# TODO 2: register the ERR trap (single quotes!) before calling publish.

publish "$1"
