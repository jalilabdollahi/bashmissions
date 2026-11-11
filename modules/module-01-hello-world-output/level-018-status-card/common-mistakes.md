# Common Mistakes

- **Putting exit before the other output.** Nothing after exit runs, so the card would be incomplete.
  Wrong: `exit "$STATUS_CODE"` first, then the printf lines.
  Right: exit as the final line.
- **Sending the log note to stdout.** The card then gains an extra line, and tests that read only the card fail.
  Wrong: `echo "card printed for $SERVER"`
  Right: `echo "card printed for $SERVER" >&2`
- **Quoting the here-document marker.** `cat <<'EOF'` keeps `$SERVER` literal, so the header shows the variable name.
- **Mismatching the widths.** `%-12s` for the label and `%5d` for the number; changing either moves the whole column.
- **Typing the script name.** `$(basename "$0")` follows renames; a typed name does not.
