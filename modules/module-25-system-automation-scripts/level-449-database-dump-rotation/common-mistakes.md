# Common Mistakes

- **No `pipefail`.** `pg_dump db | gzip > f` reports success even if pg_dump failed, and the half dump is kept as "good".
  - Right: `set -o pipefail` and test the pipeline.
- **Pruning before dumping.** If the dump then fails, the old copies are already gone.
  - Right: prune only in the code that runs after the new dump is verified.
- **A sloppy glob.** `"$outdir/$db"-*.sql.gz` for `app` also matches `app-staging-2026...`, and you delete another database's backups.
  - Right: require digits, `"$outdir/$db"-[0-9]*.sql.gz`.
- **Writing straight to the final name.** A crash leaves `app-20260301.sql.gz` that is truncated and looks real.
  - Right: write `.partial`, `gzip -t`, then `mv`.
- **Allowing `KEEP=0`.** The prune loop then deletes the dump you just created.
  - Right: reject anything below 1.
