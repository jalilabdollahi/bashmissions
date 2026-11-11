# Common Mistakes

- **Calling before defining.** Putting `rule` on line 2 and the definition on
  line 5 gives `rule: command not found`. Right: define first, call after.
- **Writing parentheses when calling.** `rule()` on its own line is another
  *definition* attempt and fails with a syntax error. Right: just `rule`.
- **Forgetting the semicolon or newline before the closing brace on one line.**
  `rule() { echo hi }` fails. Right: `rule() { echo hi; }` or put `}` on its own
  line.
- **Defining it and expecting output.** A script that only contains
  `rule() { echo "====="; }` prints nothing. The call is a separate step.
