# Common Mistakes

- **Quoting the regex.**
  Wrong: `[[ $line =~ "^[0-9]+$" ]]` (searches for the literal text `^[0-9]+$`).
  Right: `re='^[0-9]+$'; [[ $line =~ $re ]]`.
- **Inline regexes with spaces or bars.** `[[ $s =~ a b|c ]]` is a syntax error.
  Put the pattern into a single-quoted variable.
- **Double quotes around the whole regex in the assignment.** `re="^[0-9]+$"`
  lets the shell try to expand `$"`; backslashes also get eaten.
  Use single quotes: `re='^[0-9]+$'`.
- **Expecting literal matching without quotes.** `[[ $line =~ $text ]]` with a
  `text` of `10.0.0.1` also matches `10x0y0z1`. For "contains this text" quote
  it: `"$text"`.
- **Old advice from Bash 3.1.** Very old Bash quoted regexes by habit. Since 3.2 the
  rule above is the standard; do not copy snippets that disagree.
