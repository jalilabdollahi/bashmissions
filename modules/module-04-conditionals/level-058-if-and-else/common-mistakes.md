# Common Mistakes

- **Putting a semicolon or `then` after `else`.** `else` takes no condition and no `then`.
  - Wrong: `else then echo "clean"`
  - Right: `else` on its own line (or `else echo "clean"` on one line)
- **Using `[[ grep -q ... ]]`.** Double brackets test strings and files, they do not run commands.
  - Wrong: `if [[ grep -q ERROR "$f" ]]; then`
  - Right: `if grep -q ERROR "$f"; then`
- **Forgetting `-q`.** Without it grep prints every matching line before your own message, which pollutes the output.
  - Wrong: `if grep ERROR "$f"; then echo "needs attention"; fi` shows the log lines too
  - Right: `if grep -q ERROR "$f"; then`
- **Two separate ifs instead of if/else.** Both blocks may run, or neither.
  - Wrong: `if grep -q ERROR f; then echo bad; fi` then `if ! grep -q ERROR f; then echo ok; fi`
  - Right: one `if ... else ... fi`
