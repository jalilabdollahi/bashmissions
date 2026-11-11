# Common Mistakes

- **Using two hashes by habit.** `${url##*://}` removes up to the LAST `://`, so
  the redirect link loses its inner address. Here: one hash.
- **Forgetting the star.** `${url#://}` only removes a prefix that is exactly
  `://`; the scheme sits before it, so nothing happens. Right: `${url#*://}`.
- **Expecting regex syntax.** `${url#[a-z]*://}` happens to work, but `.`, `+` and
  `\d` do not mean what they do in a regex. Patterns here are globs.
- **Expecting it to change the variable.** `${url#*://}` only produces a new
  value. `url` still holds the whole link unless you assign the result.
