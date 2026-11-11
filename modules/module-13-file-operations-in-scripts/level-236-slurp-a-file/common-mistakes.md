# Common Mistakes

- **Forgetting the `<`.** `$("$file")` tries to run the file's name as a command.
  - Wrong: `token=$("$file")`
  - Right: `token=$(<"$file")`
- **Putting spaces or more than a redirection inside.** The short form only works with a lone `<file`.
  - Wrong: `token=$(< "$file" tr -d ' ')` (this is a different command)
  - Right: `token=$(<"$file")`, then clean the string with expansions
- **Expecting the final newline to be kept.** Command substitution strips it.
  - Wrong: `[[ ${#token} -eq 19 ]]` for an 18-character token plus newline
  - Right: count the characters you see: `${#token}` is 18
- **Not checking that the file exists.** A missing file prints a shell error and leaves `token` empty.
  - Wrong: `token=$(<"$1")` with no check
  - Right: `[[ -r $1 ]] || { echo "cannot read $1" >&2; exit 1; }` first
