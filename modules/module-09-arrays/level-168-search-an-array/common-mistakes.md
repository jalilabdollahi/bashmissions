# Common Mistakes

- **Unquoted right-hand side.** `[[ $entry == $name ]]` is a pattern match: with `name='*'` every entry matches.
  Right: `[[ $entry == "$name" ]]`
- **Substring matching.** `[[ "${allowed[*]}" == *"$name"* ]]` allows `eel` because `wheelbarrow` is in the list.
- **Grep on the joined list.** `echo "${allowed[@]}" | grep -q "$name"` has the same substring problem and also breaks on spaces and regex characters.
- **Forgetting the exit status.** Printing "allowed" and then still reaching `exit 1` at the bottom. Exit right after the match.
- **Using `-eq` for names.** `-eq` is for numbers. `[[ eel -eq dory ]]` treats both as 0 and says they are equal.
