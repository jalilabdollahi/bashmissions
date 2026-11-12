# Common Mistakes

- **Check-then-create locking.** Wrong: `[[ -e claims/$id ]] || touch claims/$id` lets two workers both pass the check. Right: `mkdir claims/$id || continue`, which fails for the second one.
- **Writing the job in place.** Wrong: `printf ... > pending/0007.job` while a worker is already scanning: it can run a half-written job. Right: write a temp file and `mv` it into `pending/`.
- **Trusting the claim alone.** Wrong: running the job as soon as `mkdir` succeeds. A claim released by a worker that already finished lets a late worker "win" and run the job a second time. Right: after claiming, check that the job file is still in `pending/`.
- **Printing from the workers.** Wrong: each background worker `echo`s its result, so the order changes from run to run. Right: write result files and print in ID order after `wait`.
- **Forgetting `wait`.** Wrong: the script ends (and removes the scratch directory with the trap) while workers are still running. Right: `wait` before reading results.
- **Sleeping after the final attempt.** Wrong: `sleep 1` at the end of every loop pass delays the failure by a pointless second. Right: sleep only when another attempt follows.
- **Leaving the lock behind.** Wrong: `rmdir queue/work.lock` as the last line, skipped when the script exits early. Right: a `trap ... EXIT`.
