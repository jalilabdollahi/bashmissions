# Common Mistakes

- **Starting the sender before the trap.** The default action of HUP kills the script.
  - Wrong: `confpush "$$" "$conf" &` then `trap on_hup HUP`
  - Right: `trap on_hup HUP` first.
- **Only setting the flag, never re-reading.** The handler must reload the data too, otherwise `$greeting` stays stale.
  - Right: call `load_config` inside the handler.
- **A silent main loop that sleeps for ages.** The trap cannot run until the current `sleep` finishes.
  - Wrong: `sleep 10` while waiting for a reload
  - Right: many short sleeps (`sleep 0.1`) in a loop.
- **Cutting the value at the second `=`.** `cut -d= -f2` returns only `x` for `x=y=z`.
  - Right: `cut -d= -f2-` or `sed -n 's/^greeting=//p'`.
- **Sending HUP to the wrong PID.** `$!` is the pusher, not the script that has the trap.
  - Right: pass `$$`.
