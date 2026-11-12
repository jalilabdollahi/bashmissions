# Common Mistakes

- **Pairing the wrong indexes.** Wrong: `${FUNCNAME[i]}` with `${BASH_LINENO[i-1]}` reports the line where the *inner* function was called. Right: both with the same `i`.
- **Printing `main`.** Wrong: `i < ${#FUNCNAME[@]}` also prints a line for the top level. Right: stop with `i < ${#FUNCNAME[@]} - 1`.
- **Starting at 0.** Index 0 is the `stack` function itself, so the report begins with a useless line about the reporter. Start at 1.
- **Forgetting `local i`.** Without it the loop variable leaks into the caller's scope and can clobber a variable of the same name there.
- **Using the array outside a function and expecting frames.** At the top level there are no callers to list, so an empty report is correct, not a bug.
