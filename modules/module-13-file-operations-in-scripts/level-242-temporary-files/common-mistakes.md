# Common Mistakes

- **Filtering a file into itself.** The shell truncates the target before the command reads it.
  - Wrong: `sort -u "$list" > "$list"` (empties the list)
  - Right: `sort -u "$list" > "$scratch"; cat "$scratch" > "$list"`
- **Inventing the scratch name.** It collides when two runs overlap and can be predicted by an attacker.
  - Wrong: `scratch=/tmp/list.$$.tmp` or `/tmp/list.tmp`
  - Right: `scratch=$(mktemp)`
- **Cleaning up only on the happy path.** An early `exit` or a failing command leaves files behind.
  - Wrong: `rm "$scratch"` as the last line of the script
  - Right: `trap 'rm -f "$scratch"' EXIT` right after `mktemp`
- **Expecting `$$` to be unique enough.** Process numbers get reused, and the name is guessable.
  - Wrong: `tmp=/tmp/work-$$`
  - Right: `tmp=$(mktemp)`
- **Not quoting the variable in the trap.** A path with spaces then breaks the `rm`.
  - Wrong: `trap "rm -f $scratch" EXIT` (expands at once, unquoted)
  - Right: `trap 'rm -f "$scratch"' EXIT`
