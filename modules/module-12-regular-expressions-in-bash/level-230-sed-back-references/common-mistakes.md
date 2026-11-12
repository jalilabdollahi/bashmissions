# Common Mistakes

- **Forgetting `-E`.** Without it, `( )` and `{2}` are literal characters in sed's
  basic regex, and nothing matches. Either add `-E` or write `\( \)` and `\{2\}`.
- **Off-by-one group numbers.** `\0` is not "the first group" (it is unspecified
  or the whole match in some seds). Groups start at `\1`.
- **Reusing the delimiter.**
  Wrong: `sed -E 's/([0-9]{2})/([0-9]{2})/.../'` (the slashes end the pattern early).
  Right: `s|...|...|` or escape each slash.
- **Missing `g` for multiple dates.** `invoice 15/09/2024 due 15/10/2024` would only
  have its first date converted.
- **Loose digits.** `([0-9]+)/([0-9]+)/([0-9]+)` also rewrites `1/2/3` and
  `ref 7/11/2024` into nonsense. Exact counts keep look-alikes out.
