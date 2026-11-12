#!/usr/bin/env bash
# Incident responder: for every rule whose metric breaches its threshold, freeze a
# snapshot of evidence (processes, disks, connections, log tails), at most once
# per cooldown, and keep only the newest N snapshots.
#   solution.sh [--cooldown SECONDS] [--keep N] RULES SAMPLE

# TODO: parse --cooldown / --keep; check RULES and SAMPLE are readable (exit 2)
# TODO: NOW = $NOW or date +%s
# TODO: validate every rule line first: field count, operator, numeric threshold, collectors (exit 3)
# TODO: load SAMPLE into an associative array; a breached() function that compares numbers in awk
# TODO: per rule: no data / ok / cooling down (incidents/.last/NAME) / snapshot
# TODO: snapshot = mktemp -d inside incidents/, trigger.txt + one file per collector,
#       a failing collector writes "collector failed", then mv into place (trap cleans a half-built one)
# TODO: update .seq, .last/NAME and INDEX, prune beyond --keep
# TODO: summary line and exit status
