#!/usr/bin/env bash
# A lock manager: the lock is a directory made with mkdir, holding `owner` and
# `expires` files. Time is never read from the clock, it is passed in as NOW.
#   acquire LOCK OWNER TTL NOW | release LOCK OWNER | status LOCK NOW

# TODO: usage() that prints the one-line usage to stderr and exits 2
# TODO: validate that TTL and NOW are positive integers
# TODO: load_holder: read owner and expires, report damaged metadata
# TODO: acquire: mkdir first; if it exists decide renew / busy / stale reclaim
# TODO: release: check the owner before removing the files and the directory
# TODO: status: free, held (seconds left) or expired
# TODO: dispatch on the first argument
