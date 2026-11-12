#!/usr/bin/env bash
# Multi-environment deployer: promote a version from one environment to the next
# only when every gate passes, verify health, roll back on failure.
#   solution.sh status APP
#   solution.sh [--dry-run] promote APP FROM TO

# TODO: argument parsing for the two commands (exit 2); NOW and the deployer identity
# TODO: load pipeline.conf: the order line and the gate lines, with validation (exit 3)
# TODO: state helpers for state/APP/ENV.version and ENV.since
# TODO: status: table of every environment with its version and age in minutes
# TODO: promote: FROM -> TO must be adjacent; version = what FROM runs; "already runs" shortcut
# TODO: evaluate ALL gates of TO (soak, tests, approval, freeze) and print one line each
# TODO: failed gates -> message and exit 1; --dry-run -> message and exit 0
# TODO: deployctl push + health, rollback to the previous version when health fails
# TODO: record version, arrival time and history only after a healthy deploy
