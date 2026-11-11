# Common Mistakes

- **Forgetting the anchors.** `[[ $q =~ [0-9]+ ]]` accepts `5O` because it
  contains a digit. Right: `[[ $q =~ ^[0-9]+$ ]]`.
- **Quoting the pattern.** `[[ $q =~ "^[0-9]+$" ]]` compares literal text, not a
  regex, so every real number is rejected. Leave the pattern unquoted.
- **Using single brackets.** `[ $q =~ ^[0-9]+$ ]` is an error: `=~` exists only
  in `[[ ]]`.
- **Using `*` instead of `+`.** `^[0-9]*$` also matches the empty string, so a
  missing value passes as a number. Use `+` for "at least one".
