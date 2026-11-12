#!/usr/bin/env bash
# User auditor: read passwd, shadow and a last-login list, inspect home directories
# and print every suspicious account.
#   solution.sh [--stale-days N] [--ignore USER]... PASSWD SHADOW LASTLOG

# TODO: parse options (--stale-days, repeatable --ignore) and check the three files
# TODO: load SHADOW hashes and LASTLOG days into associative arrays
# TODO: an add() helper that records "RANK|KIND|USER|SEV|DETAIL"
# TODO: walk PASSWD: uid 0, duplicate uids, login shell, empty password, stale login
# TODO: for homes under /home/: missing directory, or key-file permissions via ls -l
# TODO: find directories in home/ that no account owns
# TODO: sort findings (severity, kind, user), print the table and the summary, set the exit code
