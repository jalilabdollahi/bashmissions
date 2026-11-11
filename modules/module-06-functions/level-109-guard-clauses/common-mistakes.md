# Common Mistakes

- **Comparing before checking the type.** `(( gb < 1 ))` on `twenty` is treated as a
  variable name and quietly evaluates to 0 or fails. Check `=~ ^[0-9]+$` first.
- **Forgetting the `return`.** A guard that only prints the error carries on to the
  success line. Each guard needs `return N`.
- **Printing errors on stdout.** `echo "error..."` without `>&2` puts the message in
  the data stream, where a caller capturing the output would swallow it.
- **Nesting the happy path.** `if ok; then ...everything...; fi` hides the point of
  the function. Reject first, work after.
- **Reading `$?` after another command.** `set_quota ...; echo done; exit $?` exits
  with the status of `echo`. Put `exit $?` right after the call.
