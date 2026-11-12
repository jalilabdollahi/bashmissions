#!/usr/bin/env bash
# Backup verifier: restore the newest backups of every set into a scratch
# directory and compare each file with the checksum in its manifest.
#   solution.sh [--keep-last N] [--set NAME] BACKUP_DIR

# TODO: parse --keep-last / --set, check BACKUP_DIR (exit 3 on mistakes)
# TODO: scratch directory from mktemp -d, removed by a trap
# TODO: list the well-named archives, group by set, newest first (sort)
# TODO: verify_one: sums file? tar -tzf? unsafe entry? extract, then compare cksum + size
#       and collect missing / mismatch / unlisted files into $detail
# TODO: print the table rows, "set NAME: K of M ok" lines and the final tally
# TODO: exit 2 if a set has no good backup, else 1 if anything failed, else 0
