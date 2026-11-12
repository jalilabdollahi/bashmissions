# Common Mistakes

- **Running `ssh host cmd` without `-n` inside `while read`.** The script processes the first host and silently stops.
  - Right: `ssh -n host cmd`, or `ssh host cmd < /dev/null`.
- **No `BatchMode`.** A host with a changed key or no key waits for a password and the whole run hangs.
  - Right: `ssh -o BatchMode=yes`.
- **Aborting on the first failure.** With `set -e`, `out=$(ssh ...)` ends the script at the first bad host.
  - Right: `out=$(ssh ...) || rc=$?`
- **Treating every non-zero status alike.** 255 is "could not connect", while 1 or 3 is the remote command's own answer.
  - Right: check `rc == 255` first.
- **Passing the command as separate quoted words.** `ssh host "$@"` can mangle arguments with spaces because ssh re-joins them for the remote shell.
  - Right: build one string, `"$*"`, and quote it deliberately.
