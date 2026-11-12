# Common Mistakes

- **Trying to return text.** `return "full"` fails with "numeric argument
  required". `return` takes only a number 0-255. To hand back text use stdout (a
  later level).
- **Reading `$?` too late.** `echo "checking"; code=$?` saves the status of
  `echo` (0), not of your function. Right: `check_disk "$1"; code=$?`.
- **Returning from the wrong end.** Checking `>= 80` before `>= 95` returns 1 for
  97. Test the largest threshold first.
- **Leaving `set -e` on.** A deliberate `return 2` then kills the script before the
  report line is printed.
- **Using `exit` inside the function.** `exit 2` ends the entire script, not just
  the function. Use `return` unless ending the script is what you mean.
