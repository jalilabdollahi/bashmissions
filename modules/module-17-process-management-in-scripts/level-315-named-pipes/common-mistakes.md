# Common Mistakes

- **Writer and reader in the same foreground.** The first `open` waits for a partner that never comes: the script hangs.
  - Wrong: `tailfeed "$src" feed.pipe; while read -r l; do ...; done < feed.pipe`
  - Right: `tailfeed "$src" feed.pipe &` first, then the reading loop.
- **Piping into the loop and losing the counter.** The loop runs in a subshell.
  - Wrong: `cat feed.pipe | while read -r l; do n=$((n+1)); done; echo "$n"`
  - Right: `while read -r l; do ...; done < feed.pipe`
- **Plain `read` instead of `IFS= read -r`.** It trims leading spaces and eats backslashes.
  - Right: `IFS= read -r line`
- **Leaving the pipe behind.** It stays in the folder as a special file, and `mkfifo` fails with "File exists" on the next run.
  - Right: `rm feed.pipe` at the end (or in a `trap ... EXIT`).
- **Creating it with `touch` or `>`.** That makes an ordinary file, not a pipe; `tailfeed` will refuse it.
  - Right: `mkfifo feed.pipe`
