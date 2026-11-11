# Common Mistakes

- **Setting noclobber after the write.** The option only affects redirections that come after it.
  - Wrong: `echo "$text" > "$file"` then `set -o noclobber`
  - Right: `set -o noclobber` first, then redirect
- **Silencing only the command.** The failure message comes from the shell, not from `echo`.
  - Wrong: `echo "$text" > "$file" 2>/dev/null` (redirections run left to right; the error is already printed)
  - Right: `{ echo "$text" > "$file"; } 2>/dev/null`
- **Using `>>` as a workaround.** Appending is not overwriting, but it also changes what the file contains.
  - Wrong: `echo "$text" >> "$file"` to "get around" the refusal
  - Right: refuse, or use `>|` when replacing is the intent
- **Typing `|>` instead of `>|`.** That is a different thing entirely (a pipe followed by a redirect) and is a syntax error.
  - Wrong: `echo hi |> file`
  - Right: `echo hi >| file`
