# Common Mistakes

- **Not shifting the verb.** Wrong: `cmd_add "$@"` from the dispatcher while `$1` is still `add`, so the note becomes "add buy ice". Right: `shift` before the call, or pass `"${@:2}"`.
- **Shifting with no arguments.** Wrong: running `shift` when the script got none; it fails and, under `set -e`, ends the script with an unhelpful status. Right: check `$#` first and print usage.
- **Joining with `$@` instead of `$*`.** Wrong: `text="$@"` inside a longer string is ambiguous and shellcheck flags it. Right: `text="$*"` when you want one string.
- **Editing the file in place while reading it.** Wrong: `sed "${n}d" "$NOTES" > "$NOTES"` empties the file before sed reads it. Right: write to a temp file, then `mv`.
- **Trusting the number.** Wrong: using `$n` in `sed "${n}d"` before checking it is a plain number; `remove '1;d'` becomes a command. Right: match `^[1-9][0-9]*$` first.
