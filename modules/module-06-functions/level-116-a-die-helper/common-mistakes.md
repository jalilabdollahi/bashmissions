# Common Mistakes

- **`return` instead of `exit`.** `die() { echo "error: $*" >&2; return 3; }` only
  leaves the function. The script carries on and counts lines of a missing file.
- **Message on stdout.** Without `>&2` the error mixes into the output a caller may
  be capturing. Errors belong on stderr.
- **Forgetting `shift`.** Then `$*` still starts with the code, and the message
  reads `error: 3 no such file: ghost.log`.
- **Dying inside `$( )` and expecting the script to stop.** The `exit` only ends the
  substitution's subshell. Check the result afterwards.
- **Wrong check order.** Testing for an empty file before existence prints a
  confusing message for a file that is not there at all.
