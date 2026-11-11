# Common Mistakes

- **Spaces around the equals sign.**
  Wrong: `server = anchovy` (Bash reports `server: command not found`).
  Right: `server=anchovy`
- **Putting a dollar sign on the left.**
  Wrong: `$server=anchovy`. The `$` is only for reading.
  Right: `server=anchovy`, then `echo "$server"`.
- **Forgetting the dollar sign when reading.**
  Wrong: `echo "server: server"` prints the word `server` twice.
  Right: `echo "server: $server"`.
- **Typing the value twice.** `echo "server: anchovy"` passes a lazy test but ignores the whole point: the value lives in one place.
