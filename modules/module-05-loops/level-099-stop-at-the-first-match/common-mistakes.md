# Common Mistakes

- **Forgetting `-q`.** `grep` prints the matching line, which ends up in your output.
  Wrong: `if grep -E '^PermitRootLogin[[:space:]]+yes' "$file"; then`
  Right: `if grep -q -E '...' "$file"; then`
- **No anchor on the pattern.** A comment matches too.
  Wrong: `grep -q 'PermitRootLogin yes'` accepts `#PermitRootLogin yes`
  Right: `grep -q -E '^PermitRootLogin[[:space:]]+yes'`
- **Not stopping.** Without `break` the loop keeps going and the last matching file wins.
  Wrong: assigning `hit=$file` with no `break` (c.conf is reported instead of b.conf)
  Right: `hit=$file; break`
- **Using `exit` where you need to report afterwards.** Leaving the script from inside the loop skips the message you wanted to print after it.
- **Testing the variable without quotes.** `[ -n $hit ]` is true even when `$hit` is empty. Use `[[ -n $hit ]]`.
