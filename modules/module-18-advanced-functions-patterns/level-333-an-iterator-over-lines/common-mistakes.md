# Common Mistakes

- **Capturing the line with `$( )`.** Wrong: `name=$(next_line)` advances the cursor in a subshell, so the next call returns the same line again. Right: call `next_line` directly and read `LINE`.
- **Advancing before bounds-checking.** Wrong: `cursor=$((cursor+1))` first and test later hands out a line past the end (an empty value). Right: test `cursor < ${#lines[@]}`, then read, then advance.
- **Ignoring the status of the inner calls.** Wrong: calling `next_line` for plan and price without checking: a short file silently gives empty fields. Right: chain with `&&` or test each, and report the incomplete record.
- **Using a pipe to feed the loop.** Wrong: `cat file | while ...; do ...; done` runs the loop in a subshell, and variables set there vanish. Right: `mapfile` (or `done < file`).
- **Off-by-one in the message.** Reporting `$cursor` after reading the plan names the wrong line. Save `start=$cursor` right after reading the name.
