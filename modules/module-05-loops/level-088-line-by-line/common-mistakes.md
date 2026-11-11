# Common Mistakes

- **Plain `read` without `IFS=`.** Leading and trailing blanks vanish.
  Wrong: `while read -r line` turns `   indented rule  ` into `indented rule`
  Right: `while IFS= read -r line`
- **Leaving out `-r`.** Backslashes disappear or join lines.
  Wrong: `while IFS= read line` prints `C:tempnew` for `C:\temp\new`
  Right: `while IFS= read -r line`
- **Looping with `for line in $(cat file)`.** It splits on spaces, so one line becomes many items.
  Right: use the `while ... read` loop with `done < file`
- **Putting the redirect in the wrong place.** `read -r line < file` inside the body re-opens the file every round and reads the first line forever. The redirect belongs after `done`.
