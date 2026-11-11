#!/usr/bin/env bash
# Server profile card for Gus's inventory.
# Inputs: SERVER (required), ROLE, RAM_GB, DIMMS (optional with defaults),
# and the owner list in fixtures/owners.txt ("server:customer" per line).

# TODO: require SERVER - stop with "SERVER must be set" if it is missing
# TODO: lock COMPANY="Lanternfish Hosting" as read-only
# TODO: defaults: ROLE=web, RAM_GB=8, DIMMS=2
# TODO: per_dimm = RAM_GB / DIMMS in an integer variable
# TODO: capture the owner from fixtures/owners.txt (or "unassigned")
# TODO: print the six-line card
