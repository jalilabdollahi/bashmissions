# Common Mistakes

- **Wrapping the call in a test.** `if [[ is_empty_file "$f" ]]` tests whether the
  string `is_empty_file` is non-empty... and a syntax error follows. Right:
  `if is_empty_file "$f"; then`.
- **Printing instead of returning.** A function body of `echo yes` always
  succeeds, so the `if` always takes the "empty" branch. Predicates should
  *test*, not echo.
- **Mixing up the logic.** 0 is true. `return 1` for "yes, it is empty" makes the
  `if` run the wrong branch.
- **Checking existence second.** Testing `is_empty_file` before `-e` labels a
  missing file `ok`.
- **A trailing command that changes the status.** Adding `echo done` after the
  test makes the function always succeed. Keep the test last, or `return` it
  explicitly.
