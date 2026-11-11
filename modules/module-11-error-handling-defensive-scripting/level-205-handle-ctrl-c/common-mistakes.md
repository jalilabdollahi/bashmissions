# Common Mistakes

- **A handler without `exit`.** Wrong: the handler prints a message and returns; the loop continues with the next batch and prints "import complete". Right: end the handler with `exit 130`.
- **Registering the trap after the loop.** A signal arriving earlier still kills the script. Right: trap before the first batch.
- **Wrong signal name.** Wrong: `trap on_interrupt SIGNIT` or `trap on_interrupt CTRL-C`. Right: `INT` (or `SIGINT`, or the number 2).
- **Exiting with 0 or 1.** Wrong: `exit 0` tells the caller "success"; `exit 1` hides "interrupted". Right: `exit 130`, the convention for SIGINT.
- **Updating the progress variable after the work in a subshell.** Wrong: `last=$batch` inside `( ... )` or a pipe is lost, and the handler reports 0. Right: update `last` in the main shell.
