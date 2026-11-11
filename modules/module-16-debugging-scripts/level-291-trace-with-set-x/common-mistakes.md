# Common Mistakes

- **Turning tracing on too late.** Only commands that run after `set -x` are traced. Wrong: `dest=backups/$1` first, then `set -x`, so the assignment is missing from the trace. Right: `set -x` above the first command you care about.
- **Looking for the trace on stdout.** `./solution.sh x > out.txt` does not capture it; trace lines are on stderr. Use `2> trace.txt` or `2>&1` to catch them.
- **Typing `set +x` by mistake.** `+x` turns tracing off, `-x` turns it on. The sign feels backwards, but `-` means "set the option".
- **Expecting the source text.** The trace shows expanded commands: `echo "ready: $dest"` appears as `+ echo 'ready: backups/harbour'`. If you grep the trace for `$dest`, you will never find it.
- **Adding `echo` lines to imitate the trace.** `echo "dest is $dest"` has to be written and removed again for every command; `set -x` needs one line for all of them.
