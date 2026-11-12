# Common Mistakes

- **Dry run that still calls scp.** A "would push" message printed after the real copy is just a log line.
  - Right: the dry-run branch must contain no side effect at all.
- **Testing with `-e` instead of `-s`.** An empty file passes `[[ -e ]]` and wipes the config on every host.
  - Right: `[[ -s $file ]]`
- **Unquoted `host:path`.** If REMOTEPATH holds a space, `$host:$path` splits into two arguments.
  - Right: `"$host:$remote_path"`
- **Exiting on the first failed host.** One dead machine then blocks the other thirty from getting the fix.
  - Right: `if scp ...; then ...; else ...; fi` and continue.
- **Printing `pushed 3 of 3` in a dry run.** The summary must not claim copies that never happened.
