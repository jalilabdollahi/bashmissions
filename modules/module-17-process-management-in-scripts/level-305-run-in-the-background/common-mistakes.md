# Common Mistakes

- **Reading `$!` too late.** It always points to the newest job.
  - Wrong: start all the jobs in one loop, then `echo "$!"` once: you only get the last PID.
  - Right: `snapshot "$server" &` followed at once by `echo "$!" >> pids.txt`.
- **Putting `&` on the wrong line.** The `&` applies to the command it ends.
  - Wrong: `echo "$!" >> pids.txt &` backgrounds the echo, not the snapshot.
  - Right: `snapshot "$server" &`.
- **Forgetting the final `wait`.** The script exits with the snapshots still running, so the work is cut short or finishes after you are told it is done.
  - Right: end the script with `wait`.
- **Waiting inside the loop.** `snapshot "$server" & wait` starts one job, waits, then starts the next: sequential again, only with extra steps.
  - Right: start all of them first, wait once afterwards.
- **Using `$$` instead of `$!`.** `$$` is the PID of your own script, not of the job you started.
