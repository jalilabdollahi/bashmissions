# Common Mistakes

- **Validating while applying.** If manifest 5 of 8 is broken and you only find out when you reach it, apps 1-4 are already deployed from a repo that cannot be trusted. Parse and validate every manifest first.
- **Pulling before taking the lock.** Two deployers then race on the working copy and one may deploy the other's half-pulled state. Lock, then pull.
- **Writing the state file before the health check.** The state file should mean "last known good". If you write it first, a rollback has nothing to go back to. Write it only after `healthctl` says yes.
- **Rolling back with the NEW replicas and port.** The rollback must use the old values; read them into separate variables before the change.
- **Pruning by default.** A typo that renames `web.app` makes `web` an orphan and deletes the shop. Report orphans and require `--prune` to remove them.
- **No change budget.** A bad merge that touches forty manifests deploys forty changes in a minute. A limit forces a human to look.
- **Forgetting to release the lock on failure.** `exit 1` in the middle of the loop leaves `.lock` behind and every later run says "another deploy is running". Use `trap ... EXIT`.
- **Letting a dry run write anything.** An audit line or state file written in "dry" mode is a lie; keep the preview side-effect free.
