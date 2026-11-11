# Common Mistakes

- **Counting from 1.** `${fields[1]}` is the second field (`x`), not the user
  name. The user is `${fields[0]}`.
- **Setting IFS globally.** `IFS=:` on its own line changes word splitting for the
  entire script and breaks later loops. Put it in front of the command, as in
  `IFS=: read -ra fields <<< "$line"`.
- **Forgetting the here-string.** `IFS=: read -ra fields "$line"` treats the line
  as an extra variable name, and `read` waits on stdin. Use `<<< "$line"`.
- **Writing `$fields[2]`.** Without braces Bash prints element 0 followed by the
  text `[2]`. Array elements need `${fields[2]}`.
