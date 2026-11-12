#!/usr/bin/env bash
# Nightly database dump with rotation: dump -> compress -> verify -> rename,
# and only after that prune old dumps beyond KEEP. A failure stops before pruning.

# TODO: usage; validate DB name and KEEP
# TODO: mkdir -p OUTDIR, pipe pg_dump into gzip writing a .partial file
# TODO: if the pipeline fails: remove the partial, message, exit 1 (no pruning!)
# TODO: gzip -t the partial and rename it
# TODO: list this database's dumps precisely (DB-digits.sql.gz), delete all but the newest KEEP
# TODO: the "kept K dumps" line
