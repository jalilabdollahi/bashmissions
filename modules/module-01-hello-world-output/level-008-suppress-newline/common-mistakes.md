# Common Mistakes for Suppress Newline

- Using `echo "LEVEL 8: Suppress Newline | $1 | $2"` without `-n`.
  This adds a trailing newline, which will fail the exact comparison.

- Forgetting to quote `"$1"` or `"$2"`.
  Unquoted arguments break with inputs containing spaces (e.g., `spaces allowed`).

- Only using `$1` and missing `$2`.
  The output requires both arguments separated by ` | `.

- Using `printf 'LEVEL 8: Suppress Newline | %s | %s\n'` instead of `echo -n`.
  That works but misses the `echo -n` concept this level is teaching.

- Getting the output format wrong.
  The required format is exactly `LEVEL 8: Suppress Newline | <arg1> | <arg2>` — spacing and pipe separators must match exactly.
