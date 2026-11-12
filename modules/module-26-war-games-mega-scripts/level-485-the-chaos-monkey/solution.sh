#!/usr/bin/env bash
# Seeded chaos monkey for the Lanternfish fleet. Same SEED, same faults, every
# time, because the randomness is a small LCG written in shell arithmetic.
#   solution.sh [--dry-run] SEED ROUNDS FLEET
# Environment: CHANCE (0..100, default 50) = percent of rounds that break something.

# TODO: parse --dry-run, validate SEED / ROUNDS / CHANCE, check FLEET is readable
# TODO: collect the unprotected services from FLEET, in file order
# TODO: next(): state = (state * 1103515245 + 12345) & 2147483647; rnd = state >> 16
# TODO: per round draw in the documented order: roll, target, fault, parameter
# TODO: build the description, then print it (dry run) or inject, status, heal, status
# TODO: count faults and unhealed rounds; print the summary; exit 1 if any unhealed
