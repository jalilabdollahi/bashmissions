# Common Mistakes

- **Sequential checks.** Wrong: `for each service; do check; done` with a 3-second timeout, so 10 dead hosts take 30 seconds. Right: start each check with `&` in a subshell and `wait` once.
- **Output in completion order.** Wrong: each background job prints straight to the terminal, so rows appear in random order. Right: each job writes to `$work/$i`, and the main script prints files in index order.
- **Forgetting `wait`.** Wrong: reading the result files right after starting the jobs: they are empty or missing. Right: `wait` before reading.
- **Colouring before padding.** Wrong: `printf '%-8s' "$colored_state"` counts the invisible escape bytes and the columns shift. Right: pad first, then wrap in colour codes.
- **`df` without `-P`.** Wrong: `df /data | awk 'NR==2 {print $5}'` breaks when a long device name makes `df` wrap the line. Right: `df -P`.
- **Validating while running.** Wrong: discovering an unknown type on line 14 after printing half a board. Right: validate the whole config first and exit 3.
