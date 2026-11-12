# Common Mistakes

- **Starting min and max at 0.** With `80 95 300` the "minimum" would be 0. Start
  both at the first value.
- **Reading with a pipe.** `stats "$@" | read -r min max sum` runs `read` in a
  subshell, and the variables vanish. Use `<<< "$(...)"` or process substitution.
- **Debug text in the function's output.** An extra `echo` makes the line four words
  long and `sum` receives junk. Messages go to stderr.
- **Forgetting the quotes in `"$(stats "$@")"`.** Without outer quotes the
  whitespace is re-split, which is mostly harmless here but breaks if values can
  contain spaces. Without the inner quotes arguments with spaces fall apart.
- **Calling `stats` with no arguments.** `$1` is unset under `set -u`. Guard first.
