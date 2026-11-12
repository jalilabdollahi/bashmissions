# Common Mistakes

- **Writing the ledger before the migration runs.** If `dbexec` then fails, the ledger says it succeeded and it will never be retried. Append after success only.
- **Writing the ledger once at the end.** A crash after migration 3 of 5 leaves 1-3 applied but unrecorded, and the next run applies them again. Record each success immediately.
- **Continuing after a failure.** Migration 4 may assume migration 3 worked. Stop at the first failure.
- **Ignoring edited files.** Without the fingerprint check, a change to an applied file silently makes servers diverge. Compare `cksum` with the ledger before doing anything.
- **Sorting ids numerically with `sort -n` on padded strings, or not at all.** The glob order of files is not guaranteed to be id order when names differ. Collect ids and sort them explicitly.
- **Treating a pending id below the newest applied one as normal.** It has never run here and it did run on other servers earlier or later: that is exactly how schemas drift. Refuse unless explicitly allowed.
- **Rewriting the ledger in place for `down`.** A crash in the middle leaves a truncated ledger. Write a temp file and `mv` it over.
