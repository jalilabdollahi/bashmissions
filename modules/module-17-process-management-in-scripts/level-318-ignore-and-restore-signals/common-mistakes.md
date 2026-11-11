# Common Mistakes

- **Mixing up `''` and `-`.** They are opposites.
  - Wrong: `trap - TERM` to ignore, or `trap '' TERM` to restore
  - Right: `trap '' TERM` ignores; `trap - TERM` restores the default.
- **Installing a handler when you wanted a shield for children.** Handlers are reset in child programs; only "ignore" is inherited.
  - Wrong: `trap 'echo nope' TERM` and expecting `worker` to survive
  - Right: `trap '' TERM`
- **Never lifting the shield.** The script can no longer be stopped politely, and every program it starts inherits that.
  - Right: restore with `trap - TERM` as soon as the critical section ends.
- **Letting the non-zero status stop the script.** The second worker dies with 143.
  - Wrong: `worker` alone under `set -e`
  - Right: `status=0; worker || status=$?`
- **Trying to ignore SIGKILL.** `trap '' KILL` does nothing; the kernel never lets a process ignore signal 9 (or STOP).
