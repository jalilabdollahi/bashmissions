# Common Mistakes

- **Using a variable as the end of the range.** Braces expand before variables do.
  Wrong: `for n in {08..$last}; do` (the loop runs once with the literal text)
  Right: type the number, or use a counting loop (next level).
- **Dropping the leading zero.** Without it you lose the padding and the output no longer matches.
  Wrong: `{8..12}` gives `8 9 10 11 12`
  Right: `{08..12}` gives `08 09 10 11 12`
- **Spaces inside the braces.** The expansion only happens when there is no space.
  Wrong: `{08 .. 12}`
  Right: `{08..12}`
- **Putting the range in quotes.** Quoted braces are plain text.
  Wrong: `for n in "{08..12}"; do` runs once and prints `{08..12}`
  Right: `for n in {08..12}; do`
