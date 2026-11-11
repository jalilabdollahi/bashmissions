# Common Mistakes

- **No timeout.** Against a filtered port `nc -z host 22` waits for minutes and the cron job piles up.
  - Right: `nc -z -w 2 host 22`
- **Reading `$?` after another command.** An `echo` between `nc` and the test overwrites the status.
  - Right: use the command as the condition: `if nc -z -w 2 "$h" "$p"; then`
- **Running nc bare under `set -e`.** A closed port makes the script exit immediately, so the remaining ports are never checked.
  - Wrong: `nc -z -w 2 "$host" "$port"` on its own line
  - Right: put it inside `if` (or follow it with `|| true`).
- **Forgetting `shift`.** Looping over `"$@"` including the host tries to scan a port called `mail.lanternfish.example`.
- **Assuming "open" means "healthy".** A port that accepts connections says nothing about whether the service answers correctly; it is only the first layer of checking.
