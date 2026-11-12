# Walkthrough: The Job Queue

## The plan
A queue needs three things: a place where waiting work lives, a way for several workers to take work without
colliding, and a story for what happens when work fails or the worker dies. On a single machine the file
system provides all three. A job is a small file; its *state is the directory it is in* (`pending/`, `done/`,
`failed/`); moving it is a state change; and `mkdir` is the atomic "I own this" stamp.

## Step by step
1. **Submit.** The counter in `queue/.next` gives the next four-digit ID (`printf -v id '%04d'`), which also makes
   a plain `ls` sort jobs in submission order, FIFO for free. The job is written to a temporary name first and then
   `mv`d into `pending/`: a rename inside one filesystem is atomic, so a worker never reads half a job.

2. **The run lock.** `mkdir queue/work.lock` is both the check and the acquisition, with no race between "does it
   exist?" and "create it". A trap removes the lock however the run ends, including `exit 1` for failed jobs.

3. **Recovery.** If a previous run was killed, its claims are still on disk while the jobs are still in
   `pending/`. Because the lock guarantees nobody else is running, every such claim is stale and can be removed.
   The job simply becomes claimable again.

4. **Selecting work.** The pending IDs in ascending order, truncated by `--limit`. All workers share this list.

5. **A worker** is a function. It walks the IDs in order and tries `mkdir queue/claims/ID`. If that fails someone
   else owns the job and it moves on. The winner first checks that the job is still in `pending/` (a slow worker can win `mkdir` for a job that a faster one finished and released a moment ago; it then gives the claim back), and then runs the command with `bash -c`, output captured to a scratch
   file, up to `--max-tries` times, pausing with `sleep 1` between failures (not after the last). Success or failure,
   the job and its output move to `done/` or `failed/`, the claim is removed, and a one-line result is written to
   a scratch directory.

6. **The pool.** `worker &` repeated W times, then one `wait`. Background workers cannot print results in a sensible
   order, so they write result files; after `wait` the main script reads them in ID order and prints the report. The
   report is therefore identical on every run, however the scheduler interleaved the workers.

7. **Housekeeping commands.** `status` derives the state from the directories (a pending job with a claim is
   *running*), `retry` moves a failed job back, `log` prints the captured output.

## Try it by hand
```
./solution.sh submit --name tides echo hello
./solution.sh work --workers 3
./solution.sh status
```

## Alternative
A single `queue.txt` with one line per job is simpler but needs a lock around every read-modify-write, and
two workers appending at once can interleave lines. One file per job and one directory per state turns every
state change into a single atomic `mv`.
