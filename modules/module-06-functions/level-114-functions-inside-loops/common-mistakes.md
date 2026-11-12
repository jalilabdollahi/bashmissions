# Common Mistakes

- **Counting inside a pipeline.** `cat file | while read ...; do rows=$((rows+1))`
  loses `rows` when the loop's subshell ends. Read from stdin or `< file` directly.
- **Passing the line instead of fields.** `print_row "$line"` hands over one
  string. Read two variables and pass both: `print_row "$host" "$pct"`.
- **Leaving out `-r`.** Plain `read` eats backslashes in the data. Use `read -r`.
- **Skipping blank lines too late.** A blank line gives an empty `$pct`, and
  `(( pct >= 90 ))` or `%3d` fails or prints junk. Check before the call.
- **Forgetting `%%`.** A single `%` in a printf format starts a conversion;
  `printf '%3d%'` prints an error.
