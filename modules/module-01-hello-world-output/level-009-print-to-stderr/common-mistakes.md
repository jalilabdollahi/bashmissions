# Common Mistakes for Print to Stderr

- Printing to stdout instead of stderr.
  `echo "Error: $1"` without `>&2` will fail — the validator expects empty stdout.

- Forgetting `>&2` after the echo command.
  The redirection must come at the end: `echo "Error: $1" >&2`.

- Using `2>&1` instead of `>&2`.
  `2>&1` redirects stderr TO stdout (the opposite direction).

- Getting the prefix wrong.
  The required format is `Error: <arg1>` — include the colon and space.
