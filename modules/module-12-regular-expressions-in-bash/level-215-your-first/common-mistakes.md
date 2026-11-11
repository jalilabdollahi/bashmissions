# Common Mistakes

- **Forgetting that a space ends the pattern.**
  Wrong: `[[ $line =~ Failed password ]]` is a syntax error.
  Right: `[[ $line =~ Failed\ password ]]` (or put the regex in a variable).
- **Using `==` and expecting a search.** `[[ $line == "Failed password" ]]` is
  only true when the *whole* line is exactly that. `=~` searches inside.
- **Assuming case does not matter.** `failed password` does not match
  `Failed password`. Regexes are case-sensitive unless you spell out both
  cases, for example `[Ff]ailed`.
- **Using single brackets.** `[ $line =~ Failed ]` fails with "binary operator
  expected": `=~` only exists in `[[ ]]`.
- **Dropping the last line.** A file that does not end in a newline loses its
  final line with a plain `while read`. Keep `|| [[ -n $line ]]`.
