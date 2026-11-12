# Common Mistakes

- **Trap before the lock check.** Wrong: `trap 'rm -f "$lock"' EXIT` first, then `[[ -e $lock ]] && exit 7`. The second run deletes the first run's lock. Right: check, create, then trap.
- **Reading the previous version too late.** Wrong: writing `state/$app.version` and then reading it for the rollback target (you roll back to the version that just failed). Right: read it into `previous` before the first stage.
- **A stage failure killing the script under `set -e`.** Wrong: `run_stage build ...` on its own line, so the script dies silently with no message or exit code 3. Right: `if ! run_stage build ...; then ... exit 3; fi`.
- **Sleeping after the last attempt.** Wrong: `sleep 5` at the end of every loop pass, so a dead service costs 15 seconds before the rollback. Right: only `sleep` when `attempt < 3`.
- **Recording success too early.** Wrong: writing the version file right after the deploy stage. A failed verify then leaves the bad version recorded as live. Right: write it only after verify passes.
