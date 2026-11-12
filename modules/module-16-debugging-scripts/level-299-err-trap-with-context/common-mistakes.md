# Common Mistakes

- **Double quotes around the trap text.** Wrong: `trap "echo $BASH_COMMAND" ERR` expands immediately and reports the `trap` line forever. Right: `trap 'echo "$BASH_COMMAND"' ERR`.
- **Reading `$?` after another command.** Wrong: `trap 'echo "failed"; echo "status $?"' ERR` prints the status of the first echo (0). Right: `status=$?` as the first thing in the handler.
- **Forgetting the capital E.** With plain `set -e` the trap does not fire for failures inside `publish()`; the script dies silently. Use `set -eE`.
- **Registering the trap after the call.** `publish "$1"` first, `trap ...` later: the trap is not there when the failure happens. Register it before.
- **Expecting the trap to stop the script.** The trap only reports. `set -e` is what ends the script, with the failing command's own status.
