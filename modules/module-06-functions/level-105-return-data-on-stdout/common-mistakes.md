# Common Mistakes

- **Using `return` for the text.** `return "$slug"` fails: only numbers 0-255.
  Right: `echo "$slug"` and capture with `$( )`.
- **Debug output in the result.** An `echo "cleaning..."` inside `domain_for`
  ends up inside `$address`. Send messages to stderr: `echo "cleaning..." >&2`.
- **Forgetting the capture.** A bare `domain_for "$name"` prints to the screen and
  the variable `address` stays empty.
- **Unquoted call.** `$(domain_for $name)` splits "Harbour Bakery" into two
  arguments, so the function only sees `Harbour`. Quote: `"$name"`.
- **Using `echo` with odd input.** If a name started with `-n`, `echo` would swallow
  it as an option. `printf '%s' "$1"` is safe for any text.
