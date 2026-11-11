# Common Mistakes

- **Double quotes around the trap command.** Wrong: `trap "echo $count" EXIT` expands `$count` when the trap is set, so it always shows the old value. Right: single quotes `trap 'echo $count' EXIT`, or a function.
- **Registering after the risky command.** Wrong: `lanternbuild` first, `trap ... EXIT` below it; a crash skips the registration. Right: touch the lock, trap immediately, then work.
- **Using `rm` without `-f`.** If the lock was never created (an early failure), `rm deploy.lock` prints an error inside the trap. Right: `rm -f deploy.lock`.
- **Expecting the trap to change the exit status.** `trap 'echo bye' EXIT` leaves the script's status alone. To change it you would have to call `exit N` inside the trap, which you rarely want.
- **Putting an `exit` in the cleanup function.** It ends the script early and can cause confusing double cleanups. Let the trap run, then fall off the end.
