# Common Mistakes

- **Comparing as text.** Wrong: `[ "$(id -u)" = 0 ]` fails for `00` and is easy to misquote. Right: `(( $(id -u) == 0 ))`.
- **Checking after the first action.** Wrong: running `mv` and then testing the user id; the damage is done. Right: guard on the first lines.
- **Using `whoami`.** Wrong: `[[ $(whoami) == root ]]` breaks when a second account has uid 0 or root is renamed. Right: the numeric id, 0.
- **Printing the refusal to stdout.** Wrong: `echo "refusing..."` mixes into the output that other scripts parse. Right: `>&2`, and exit non-zero.
- **Exiting with 0.** Wrong: `exit` after the message reports success to cron. Right: `exit 1` (or another non-zero code).
