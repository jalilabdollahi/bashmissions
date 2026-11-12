#!/usr/bin/env bash
# Self-healing watchdog. For each service in the PLAYBOOK: detect with
# `svcctl status`, try the listed remedies one by one (waiting GRACE seconds and
# re-checking after each), page a human when nothing works, and refuse to keep
# fixing a service that is sick on every run.
#   solution.sh PLAYBOOK STATE

# TODO: arguments + validate GRACE, MAX_ACTIONS, FLAP_LIMIT
# TODO: parse the playbook, reject unknown actions BEFORE doing anything
# TODO: lock with mkdir "$STATE.lock" and release it with a trap on EXIT
# TODO: load the per-service heal counters from STATE
# TODO: per service: status (0 healthy, 3 unknown, else sick), flap check
# TODO: remediation loop with a global action budget; verify after each action
# TODO: page when unhealed; keep exact counters for the summary
# TODO: rewrite STATE sorted, print the summary, exit 1 if anything failed
