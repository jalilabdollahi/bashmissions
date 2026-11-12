# Common Mistakes

- **Using `exit 1` everywhere.** Wrong: all four problems end with `exit 1`, so the dashboard shows the same red light. Right: `exit 3` for the missing file, `exit 4` for a bad config, and so on.
- **Message and exit in different places.** Wrong: `echo "..." >&2` without `exit` keeps running and later prints "healthy". Right: pair them: `echo "..." >&2; exit 4`.
- **Forgetting that `$?` changes.** Wrong: `probe "$port"; echo "down" >&2; exit $?` exits with echo's 0. Right: `if ! probe ...; then ...; exit 5; fi`, or save the status first.
- **Codes above 255.** `exit 256` wraps around to 0, which means success. Keep codes between 1 and 255, and avoid 126 to 165, which the shell uses for its own purposes.
- **Failing grep under strict mode.** `grep '^port=' f | cut ...` returns 1 when no line matches; with `set -e` and pipefail the script dies with the wrong code. Right: `|| true` on that line, then test the value yourself.
