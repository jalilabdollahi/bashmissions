# Common Mistakes

- **No way out of the loop.** `select` never ends by itself while the input lasts.
  Wrong: a menu without a quit entry and no `break` (at a terminal you are stuck until Ctrl-C)
  Right: add a `quit` item and `break` on it
- **Testing the number instead of the word.** After a choice `$server` holds the word, not the number.
  Wrong: `case $server in 2) ...` never matches
  Right: `case $server in barracuda) ...`
- **Using `$server` to report invalid input.** It is empty then.
  Wrong: `echo "unknown choice: $server"` prints nothing after the colon
  Right: `echo "unknown choice: $REPLY"`
- **Expecting the menu on stdout.** It goes to stderr. Redirecting stdout to a file will not capture it, and `2>/dev/null` hides it.
- **Letting the end-of-input status leak out.** `select` returns 1 when stdin ends, so without a final `exit 0` the session looks like a failure.
- **Forgetting the quotes on an empty pattern.** In `case`, write `"")` to match the empty string.
