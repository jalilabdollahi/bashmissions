# Common Mistakes

- **Sending the signal before the trap exists.** The default action of USR1 ends the script.
  - Wrong: `kill -USR1 $$` first, `trap ... USR1` afterwards (the script dies with status 138 or 158).
  - Right: all `trap` lines first.
- **Using `$!` or a literal PID.** `$$` is the script itself; `$!` is the last background job.
  - Right: `kill -USR1 $$`
- **Calling the handler yourself.** A direct `on_usr1` call works in this harness but proves nothing about the trap, which is what a real daemon depends on when someone else sends the signal.
  - Right: let `kill -USR1 $$` reach the trap.
- **A handler that blocks or runs long.** It fires between two commands of the main flow and holds it up.
  - Right: set a flag or print, then return.
- **Expecting the handler's variable changes to be lost.** A trap runs in the main shell, so they stay. That is different from a subshell.
