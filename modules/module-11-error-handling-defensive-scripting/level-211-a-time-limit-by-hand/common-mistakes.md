# Common Mistakes

- **Forgetting the `&`.** Wrong: `lanternscan` in the foreground blocks until it ends, so the sleep and the kill never get a turn. Right: `lanternscan &`.
- **Reading the wrong PID.** Wrong: `pid=$$` is the script's own PID, and `kill $$` would kill you. Right: `pid=$!` straight after the `&` line.
- **Skipping the liveness test.** Wrong: `kill "$pid"` unconditionally prints "No such process" when the scan already finished, and "times out" a healthy run. Right: `if kill -0 "$pid" 2>/dev/null; then ...`.
- **No `wait` after the kill.** The shell may report "Terminated" later, output arrives after your message, and the job's status is never collected. Right: `kill "$pid"; wait "$pid" 2>/dev/null`.
- **Using `set -e` around `wait`.** `wait` returns the job's non-zero status and kills the script before you can classify it. Right: capture with `wait "$pid"; status=$?` without errexit, or use `wait "$pid" || status=$?`.
