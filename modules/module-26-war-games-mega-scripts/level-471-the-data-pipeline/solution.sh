#!/usr/bin/env bash
# Order data pipeline for the partner files in INBOX: ingest, validate, deduplicate,
# transform, load into db/orders.psv, and report. Safe to run twice.
#   solution.sh [--dry-run] INBOX

# TODO: argument handling (exit 2), the "inbox is empty" case, a scratch dir with a trap
# TODO: copies of the loaded ids (db/orders.psv) and processed files (state/processed.list)
# TODO: ingest: strip CR, check the header (quarantine), cksum against the processed list (skip)
# TODO: one awk program: validate in the given order, reject with a reason, deduplicate,
#       transform (trim, upper-case SKU, total = qty * price) and count everything
# TODO: load: append to db/orders.psv, rejects to rejects/NAME.rej, record cksum, archive the file
#       (none of it in --dry-run mode)
# TODO: report: per-file line, totals, quarantined / skipped, rejected-by-reason, exit status
