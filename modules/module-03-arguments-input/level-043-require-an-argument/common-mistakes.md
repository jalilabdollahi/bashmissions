# Common Mistakes

- **Printing the usage on stdout.** `echo "usage: ..."` without `>&2` ends up in
  pipes and files. Right: `echo "usage: ..." >&2`.
- **Forgetting `exit`.** Without it the script prints the usage and then runs the
  lookup anyway. Right: `{ echo "..." >&2; exit 2; }`.
- **Checking after use.** `echo "Looking up: $1"` before the guard crashes with
  `unbound variable` under `set -u`. Guard first.
- **Missing the space inside braces.** `{echo "x" >&2; exit 2;}` is a syntax
  error. Write `{ echo "x" >&2; exit 2; }` with spaces and the final semicolon.
