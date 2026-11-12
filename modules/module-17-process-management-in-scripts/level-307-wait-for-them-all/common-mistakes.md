# Common Mistakes

- **Waiting inside the start loop.** It turns parallel into sequential.
  - Wrong: `vmbackup "$s" & wait $!`
  - Right: start all in one loop, wait in a second loop.
- **Printing when a job finishes.** The order then depends on timing and the test fails now and then.
  - Right: store the status, print after the last `wait`.
- **Losing the pairing between names and statuses.** Sorting one array but not the other mixes up results.
  - Right: keep both arrays in start order and use the same index `i`.
- **A bare `wait` before the per-PID waits.** It consumes all the jobs, and later `wait "$pid"` calls report 127 ("not a child") or lose the status.
  - Right: only ever `wait "$pid"` for jobs whose status you need.
- **Forgetting the empty case.** With no arguments the loops simply do nothing; the summary still has to print `0 ok, 0 failed`.
