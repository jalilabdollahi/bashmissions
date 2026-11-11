# Common Mistakes

- **Vague wording.** Wrong: `echo "error: bad config" >&2`. Right: say which file and line and what is wrong: `error: pub.conf:3: not a key=value line: "port 9000"`.
- **Forgetting stderr.** Wrong: `echo "error: ..."` lands on stdout and mixes with real output. Right: `echo "error: ..." >&2` on every error line, both of them.
- **Hiding the culprit.** Wrong: `not a key=value line: $line` for `"  "` prints an empty-looking message. Right: wrap the value in quotes: `\"$line\"`.
- **Off-by-one line numbers.** Wrong: starting the counter at 0, or counting after the check. Right: `lineno=$(( lineno + 1 ))` first thing in the loop, before any `continue`, so blank and comment lines are counted too.
- **A fix nobody can follow.** Wrong: `fix: correct the file`. Right: give the replacement syntax or command, as in `fix: add a line such as domain=example.com`.
