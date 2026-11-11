# Common Mistakes

- **Mixing up the direction.** `>` would overwrite your message file with the tool's output.
  - Wrong: `lantern-mail "$recipient" > "$file"` (empties the notice!)
  - Right: `lantern-mail "$recipient" < "$file"`
- **Passing the file as an argument.** The tool does not take a file argument; it would treat it as a second recipient or fail.
  - Wrong: `lantern-mail "$recipient" "$file"`
  - Right: `lantern-mail "$recipient" < "$file"`
- **Forgetting that a missing file stops the command.** Without a check, you get the shell's own message instead of yours, and `lantern-mail` never runs.
  - Right: test with `[[ -r $file ]]` first
- **Unquoted file names.** A name with a space splits into two words and `<` then fails with "ambiguous redirect".
  - Wrong: `lantern-mail "$r" < $file`
  - Right: `lantern-mail "$r" < "$file"`
