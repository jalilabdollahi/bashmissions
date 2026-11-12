# Common Mistakes

- **Reading the header and the loop from different redirections.** Each `< "$1"` reopens the file at line 1, so the header comes back as data.
  Wrong: `read -r h < "$1"; while read ...; done < "$1"`
  Right: `{ read -r h; while read ...; done; } < "$1"`
- **Setting IFS globally.** `IFS=,` on its own line changes how every later unquoted expansion splits. Write it in front of `read` (`IFS=, read -r ...`) so it dies with that command.
- **Forgetting the last line without a newline.** `while read -r a b` silently drops it, and the final invoice vanishes from the report. Use `|| [[ -n $a ]]`.
- **Comparing a field that still has a `\r`.** `[[ $status == open ]]` is false for `open\r`, and nothing looks wrong on screen. Strip with `${status%$'\r'}` first.
- **Too few variables.** With `read -r invoice customer rest`, `rest` is `120.50,open`, not the amount. Name one variable per column.
