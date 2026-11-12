# Common Mistakes

- **Using string syntax on the wrong thing.** `${machines:1:2}` (no `[@]`) slices the characters of element 0, not the list.
  Right: `${machines[@]:1:2}`
- **Negative offset without a space or variable.** `${machines[@]:-2}` means "default value", not "last two".
  Right: `${machines[@]: -2}` or `${machines[@]:$offset}` with `offset=-2`.
- **Mixing up count and end position.** The second number is how many elements, not where to stop. `:1:3` takes indexes 1, 2 and 3.
- **Dropping the quotes.** `wave=(${machines[@]:1:2})` re-splits names with spaces.
- **Expecting the slice to shorten the original.** `${machines[@]:1}` does not change `machines`. Assign it: `machines=("${machines[@]:1}")`.
