# Common Mistakes

- **Writing the class name without the outer brackets.**
  Wrong: `[:digit:]` (matches one of the characters `: d i g t`).
  Right: `[[:digit:]]`.
- **Thinking a class matches several characters.** `[a-z]` is one letter. The tag
  `rack-bc07` needs `[a-z]+` (next level), it does not fit `[a-z]`.
- **Using `\d` or `\w`.** `[[ 7 =~ \d ]]` is not portable POSIX; use `[[:digit:]]`
  and `[[:alnum:]_]`.
- **Forgetting the anchors.** Without `^` and `$` the string `xrack-d42x` still
  matches, because the valid piece is somewhere inside it.
- **Putting a dash in the wrong place.** In a set a dash between two characters is
  a range. To mean a plain dash, put it first or last: `[a-z-]`.
