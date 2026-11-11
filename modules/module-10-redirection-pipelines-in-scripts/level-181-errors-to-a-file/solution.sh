#!/usr/bin/env bash
# Run nightly-backup for the site in $1.
# Progress (stdout) stays on the screen. Warnings (stderr) are saved
# in backup-errors.log, which exists even if there were none.

site=$1

nightly-backup "$site"
# TODO: keep stdout on screen, but divert stderr into backup-errors.log
