# Common Mistakes

- **Counting only your own jobs.** If each worker numbers only the jobs it handles, every worker handles every job.
  - Wrong: `(( n++ ))` only inside the `if` that does the work
  - Right: increment `n` for every real job, then compare `n % workers` with the worker id.
- **Counting comments and blank lines as jobs.** They shift the numbering and make workers disagree if one skips them and another does not.
  - Right: skip them before numbering, in the same way in all workers.
- **Expecting counters to come back from the workers.** `failed=$((failed+1))` inside a background worker is lost.
  - Right: print result lines and count the collected text afterwards.
- **Leaving out the `wait` inside the group.** The report can be built before the last jobs finished.
  - Right: `{ for ...; do worker "$id" & done; wait; } | sort`
- **Splitting the job name on spaces.** `deploy $job` calls deploy with two arguments for `tidewater books`.
  - Right: `deploy "$job"` and `IFS= read -r job`
