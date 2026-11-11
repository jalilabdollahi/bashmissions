# Common Mistakes

- **Forgetting the comma in print.** `awk '{ print $NF $1 }'` prints `T-1042noor`. With the comma, `print $NF, $1` puts a space between them.
- **Using double quotes around the program.** `awk "{ print $NF }"` lets the shell expand `$NF` (to nothing) before awk sees it. Use single quotes.
- **Mixing up NF and $NF.** `print NF` prints the number of fields (say 9); `print $NF` prints the last field's text.
- **Counting from 0.** The first field is `$1`. `$0` is the whole line.
- **Expecting empty fields from double spaces.** With the default separator `a  b` has two fields, not three, unlike `cut -d' '`. That is usually a feature; to split at each single space and keep empties, use `-F'[ ]'`.
