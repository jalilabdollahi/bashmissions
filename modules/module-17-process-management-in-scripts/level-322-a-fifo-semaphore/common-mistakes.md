# Common Mistakes

- **Opening the FIFO with `<` or `>` only.** The open blocks until the other side shows up, and your script freezes before the first token.
  - Wrong: `exec 3< slots.fifo`
  - Right: `exec 3<> slots.fifo`
- **Not returning the token when render fails.** A `&&` chain skips the `echo >&3`; every failure shrinks the pool and the loop eventually hangs.
  - Wrong: `{ render "$name" && echo >&3; } &`
  - Right: `{ render "$name" || echo "$name" >> failed.log; echo >&3; } &`
- **Taking the token inside the background group.** All jobs start at once and queue up inside, so nothing limits them.
  - Right: `read -r -u 3` in the main loop, before the `&`.
- **Putting in the wrong number of tokens.** An off-by-one loop gives SLOTS+1 or SLOTS-1 seats.
  - Right: `for ((i = 0; i < slots; i++))`
- **Counting failures in a variable.** The background group is a child process; `failed=$((failed + 1))` there is lost.
  - Right: append to a file and count the lines afterwards.
