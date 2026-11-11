# Common Mistakes

- **Expecting a variable from a background job.** It is gone when the job ends.
  - Wrong: `out=$(latency "$h") &` then `echo "$out"`
  - Right: `latency "$h" > "$tmp/$n" 2>&1 &` and `cat "$tmp/$n"` after `wait`
- **Reading the files before `wait`.** They may be empty or half written.
  - Right: `wait` first, then read.
- **One shared output file for all jobs.** Lines can interleave and arrive in finishing order.
  - Wrong: `latency "$h" >> all.txt &`
  - Right: one file per job, read in order.
- **`cat "$tmp"/*` with ten or more jobs.** The shell sorts names as text, so `10` comes before `2`.
  - Right: count from 1 and loop `for ((i = 1; i <= n; i++))`.
- **Leaving the scratch folder behind.** Every run litters `$TMPDIR`.
  - Right: `rm -rf "$tmp"` at the end (and a `trap` for early exits in real scripts).
