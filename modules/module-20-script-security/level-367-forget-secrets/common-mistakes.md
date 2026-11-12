# Common Mistakes

- **Unsetting too late.** Wrong: calling `support-bundle` first and `unset API_TOKEN` after; the child already holds a copy. Right: unset directly after the last use, before any other command.
- **Forgetting copies.** Wrong: `token=$API_TOKEN; unset API_TOKEN` leaves `token` alive for `set -x` traces and later code. Right: `unset API_TOKEN token`.
- **Wiping everything.** Wrong: `env -i support-bundle ...` also drops PATH and REGION, so the tool breaks. Right: forget only the secret.
- **Clearing instead of unsetting.** Wrong: `API_TOKEN=` leaves an empty but still exported variable; harmless here, but `${API_TOKEN+x}` tests still say "set". Right: `unset API_TOKEN`.
- **Putting the secret on the command line.** Wrong: `curl -H "Authorization: Bearer $API_TOKEN"` shows up in `ps` for everyone. Right: read it from a file or stdin where the tool allows.
