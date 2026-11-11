# Common Mistakes

- **Checking first, creating second.** Another copy can slip in between.
  - Wrong: `[[ -d $lock ]] || mkdir "$lock"`
  - Right: `if ! mkdir "$lock" 2>/dev/null; then ... exit 1; fi`
- **Using `mkdir -p` for the lock.** `-p` succeeds when the folder exists, so every copy thinks it won.
  - Wrong: `mkdir -p "$lock" || exit 1`
  - Right: `mkdir "$lock"` (use `-p` only for the parent `run`)
- **Registering the trap before taking the lock.** The loser's cleanup deletes the winner's lock.
  - Wrong: `trap 'rmdir "$lock"' EXIT` then `mkdir "$lock" || exit 1`
  - Right: trap only after `mkdir` has succeeded
- **Forgetting the release.** Without the trap, one crash blocks every later run.
  - Wrong: `rmdir "$lock"` as the last line of the script
  - Right: `trap 'rmdir "$lock"' EXIT`
- **Swallowing the job's failure.** Hiding a failure makes the scheduler think the job worked.
  - Wrong: `run-job "$job" || true`
  - Right: let `set -e` stop the script, or `exit $?` explicitly
