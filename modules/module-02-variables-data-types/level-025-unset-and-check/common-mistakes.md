# Common Mistakes

- **Emptying instead of unsetting.**
  Wrong: `TOKEN=""` and then expecting `${TOKEN+set}` to be empty - it still prints `set`.
  Right: `unset TOKEN`.
- **A colon where you wanted an existence test.**
  Wrong: `${TOKEN:+set}` reports an empty token as missing.
  Right: `${TOKEN+set}` when you care about existence, not content.
- **Putting a dollar sign in `unset`.**
  Wrong: `unset $TOKEN` tries to unset a variable named after the *value* of TOKEN.
  Right: `unset TOKEN`.
- **Checking before the right moment.** Calling `${TOKEN+set}` before `unset` and expecting `after` to change. Run the test twice, once on each side of the `unset`.
