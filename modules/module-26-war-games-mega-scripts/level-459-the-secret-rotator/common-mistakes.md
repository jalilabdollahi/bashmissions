# Common Mistakes

- **Secrets on the command line.** Wrong: `awk -v new="$new" ...` or `sed "s/.../$new/"`. Anyone running `ps` sees it while the command runs. Right: `NEWVALUE=$new awk '... ENVIRON["NEWVALUE"] ...'`.
- **Losing the file mode.** Wrong: `awk ... > conf.tmp; mv conf.tmp conf` leaves the config with the default umask (often 0644). Right: `cp -p "$cfg" "$tmp"` first, then redirect into the copy.
- **Changing the database before the free checks.** Wrong: `dbctl set-password` first, then discover the config has no `KEY=`: the app now has the wrong password. Right: pre-flight checks first.
- **Rolling back with a stale `old`.** Wrong: reading `secrets/NAME.secret` after you wrote the new one, so the "restore" sets the new password again. Right: read `old` before any change.
- **Verifying with the writer's own status.** Wrong: assuming success because `mv` returned 0. Right: prove it with `dbctl check` and only then delete the backup.
- **Iterating an associative array for order.** Wrong: `for n in "${!cfg_of[@]}"` gives a random order. Right: keep a separate ordered array.
