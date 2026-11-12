# Common Mistakes

- **A fixed temp name.** Wrong: `tmp=/tmp/list.$$` is better than nothing but guessable and collision-prone. Right: `tmp=$(mktemp "${TMPDIR:-/tmp}/list.XXXXXX")`.
- **Cleanup at the end only.** Wrong: `rm -f "$tmp"` as the last line is skipped when `sort` fails. Right: `trap 'rm -f "$tmp"' EXIT` once, after mktemp.
- **Double quotes in the trap.** Wrong: `trap "rm -f $tmp" EXIT` breaks on a path with spaces, and freezes the value. Right: `trap 'rm -f "$tmp"' EXIT`.
- **Trap before the variable exists.** Wrong: `trap 'rm -f "$tmp"' EXIT` on line 2, `tmp=$(mktemp ...)` on line 5: with `set -u` the early exit trips over an unset variable. Right: create first, trap immediately after.
- **Forgetting `-f`.** If the script fails before the file is created, plain `rm "$tmp"` prints an error from inside the trap and muddies the real failure.
