# Common Mistakes

- **Deleting the comma instead of the rest.** `${row//,/}` removes the commas and
  leaves the text, so `${#...}` measures the fields. The set must be negated:
  `${row//[^,]/}`.
- **Single slash.** `${row/[^,]/}` removes only the FIRST non-comma character.
  Use two slashes for all of them.
- **Trying to nest.** `${#${row//[^,]/}}` is a syntax error in Bash. Put the
  intermediate result in a variable first.
- **Forgetting that spaces count as "not a comma".** Rows with spaces inside
  fields are fine: spaces are deleted like any other character, so
  `Gull, Anchor Pub` still contributes exactly one comma.
