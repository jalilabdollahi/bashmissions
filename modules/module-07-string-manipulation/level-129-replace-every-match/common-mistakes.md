# Common Mistakes

- **Only one slash.** `${name/ /_}` replaces the first space only:
  `north pier dental` becomes `north_pier dental`. Double it: `${name// /_}`.
- **Forgetting to assign.** `${name// /_}` on its own line does nothing visible. Use
  `name=${name// /_}` so the second pass sees the result.
- **Unescaped slash.** `${name///-}` is ambiguous. Search for a slash with
  `${name//\//-}`.
- **Deleting the search space by accident.** `${name///_}` and `${name//_}` are not
  `${name// /_}`. The space between the slashes is the search text.
