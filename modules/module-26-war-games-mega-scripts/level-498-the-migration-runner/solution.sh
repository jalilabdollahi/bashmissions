#!/usr/bin/env bash
# Migration runner. DIR holds NNN-name.up / NNN-name.down files, LEDGER records
# what was applied ("ID SUM NAME"). Migrations run through `dbexec FILE`.
#   solution.sh DIR LEDGER status | up [--dry-run] [--allow-out-of-order] [TARGET]
#                               | down [N] | verify

# TODO: usage, DIR must be a directory
# TODO: scan DIR: id, name and cksum of each .up file; remember the .down files; duplicates -> exit 2
# TODO: read the ledger into arrays keyed by id
# TODO: state ID: applied / MODIFIED / MISSING / pending
# TODO: status and verify: ascending id order
# TODO: up: refuse on edited, missing or out-of-order history; run pending in order;
#       append to the ledger after EACH success; stop at the first failure
# TODO: down: newest first, needs a .down file, then rewrite the ledger (temp file + mv)
