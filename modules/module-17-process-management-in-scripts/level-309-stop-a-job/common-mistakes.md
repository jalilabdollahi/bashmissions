# Common Mistakes

- **Killing but never waiting.** The status is lost and the dead job lingers as a zombie until the script ends.
  - Right: `kill "$pid"` followed by `wait "$pid"`.
- **Reaching for `kill -9` first.** SIGKILL gives the program no chance to clean up temp files or locks.
  - Right: plain `kill "$pid"` (SIGTERM); `-9` only when it is ignored.
- **Letting a failed `kill` end the script.** When the job finished on its own, `kill` fails, and under `set -e` that aborts the run.
  - Wrong: `kill "$pid"` on a line by itself
  - Right: `if kill "$pid" 2>/dev/null; then ...`
- **Expecting status 0 after a kill.** A job stopped by SIGTERM reports 143, not 0.
  - Wrong: `wait "$pid" && echo stopped cleanly`
  - Right: read the status and compare it with 143 if you care.
- **Killing the wrong thing.** `kill $$` ends your own script; use the PID from `$!`.
