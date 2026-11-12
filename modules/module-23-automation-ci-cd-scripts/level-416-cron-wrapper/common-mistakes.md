# Common Mistakes

- **Check-then-create locks.** Wrong: `[[ -e job.lock ]] || touch job.lock` lets two runs pass the test at once. Right: `mkdir` and look at whether it succeeded.
- **Trap before the lock.** Wrong: `trap 'rmdir "$lock"' EXIT` at the top, so a skipped run removes the lock of the job still working. Right: set the trap only after `mkdir` succeeded.
- **Losing the job's exit status.** Wrong: ending with `echo finished`, so the wrapper always exits 0 and cron or monitoring never sees failures. Right: `rc=0; "$@" || rc=$?` then `exit "$rc"`.
- **Redirecting only stdout.** Wrong: `"$@" >> "$log"` leaves error messages to vanish into cron mail. Right: `>> "$log" 2>&1`.
- **Unquoted command.** Wrong: `$*` or `$@` without quotes splits `bash -c "echo a; echo b"` into pieces. Right: `"$@"`.
