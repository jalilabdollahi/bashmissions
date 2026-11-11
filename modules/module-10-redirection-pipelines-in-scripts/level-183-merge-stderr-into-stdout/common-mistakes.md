# Common Mistakes

- **Reversing the order.** The error escapes to the terminal.
  - Wrong: `sync-tool "$target" 2>&1 > sync.log`
  - Right: `sync-tool "$target" > sync.log 2>&1`
- **Writing a space inside `2>&1`.** The shell then redirects to a file named `1`.
  - Wrong: `sync-tool "$target" > sync.log 2> &1` (syntax error) or `2> 1` (creates a file "1")
  - Right: `2>&1` with no spaces
- **Forgetting the `&`.** `2>1` writes errors into a file called `1`.
  - Wrong: `sync-tool "$target" > sync.log 2>1`
  - Right: `2>&1`
- **Reading `$?` after another command.** `echo` resets it.
  - Wrong: `sync-tool ... ; echo "running"; echo "status $?"`
  - Right: `sync-tool ... || status=$?` or read `$?` on the very next line
