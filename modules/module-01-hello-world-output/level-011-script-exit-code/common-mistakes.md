# Common Mistakes for Script Exit Code

- Forgetting `exit "$1"` — without it the script ends with the status of the last command (typically 0), so the failure tests fail silently.

- Hard-coding the exit value: `exit 1` always returns 1 and won't pass the test that runs with `7`.

- Calling `exit` *before* the `echo` line. Anything after `exit` never runs, so stdout will be empty.

- Treating `$1` as a string in arithmetic: `exit "$1"` is fine, but `exit $(($1))` will fail when the value isn't strictly numeric.

- Confusing exit code with stdout. Exit code is read from `$?`, not parsed from output. The runner checks both independently.
