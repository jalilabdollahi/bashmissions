# Common Mistakes

- **Using a glob star.**
  Wrong: `^OPS-*$` (means "OPS" followed by zero or more dashes).
  Right: `^OPS-.*$` (dash, then any characters), or better, say exactly what is allowed.
- **Quantifier on only the last character of a chunk.**
  Wrong: `-P[0-9]?` leaves "-P" mandatory. Right: `(-P[0-9])?`.
- **`*` where `+` was meant.** `[0-9]*` also matches the empty string, so
  `OPS-` would be accepted. Use `[0-9]+` or `{3,5}`.
- **Spaces inside braces.** `{3, 5}` is not a valid bound in POSIX; write `{3,5}`.
- **Escaping what needs no escape and not escaping what does.** In ERE `+ ? { } ( ) |`
  are special as they are; writing `\+` makes them literal plus signs.
