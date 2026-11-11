# Common Mistakes

- **Forgetting to silence the error.** For a dead PID `kill` prints "No such process" to stderr.
  - Wrong: `if ! kill -0 "$pid"; then`
  - Right: `if ! kill -0 "$pid" 2>/dev/null; then`
- **Polling without a pause.** A loop with no `sleep` runs thousands of checks a second and keeps one CPU at 100 percent.
  - Right: `sleep 0.1` (or longer) between looks.
- **Reading `kill -0` the wrong way round.** Success means the process is *alive*.
  - Wrong: `if kill -0 "$pid"; then echo finished; fi`
  - Right: `if ! kill -0 "$pid"; then echo finished; fi`
- **Using `kill -0` on a PID that is not yours and trusting the failure.** It can fail with "not permitted" even though the process exists.
- **Sneaking in `wait`.** A `wait` makes the loop block until the job ends, so the "still running" branch can never be reached.
