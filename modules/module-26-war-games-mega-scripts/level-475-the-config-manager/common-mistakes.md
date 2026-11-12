# Common Mistakes

- **Validating each layer on its own.** Wrong: rejecting `db.port = 99999` in the base file even though `--set` overrides it, or demanding required keys in every file. Right: merge first, then validate the final values.
- **Confusing empty with unset.** Wrong: `[[ -n ${APP_WORKERS:-} ]]` ignores a variable that is set to the empty string on purpose. Right: `[[ -v APP_WORKERS ]]`.
- **Splitting the line on every `=`.** Wrong: `cut -d= -f2` truncates `url = http://x/?a=b`. Right: split at the first `=` with `${t#*=}`.
- **Silently ignoring unknown keys.** Wrong: skipping lines whose key is not in the schema, so `db.hots` quietly leaves the default. Right: report `unknown key` with file and line.
- **Stopping at the first error.** Wrong: `exit 1` on the first bad value. Right: collect, print all, then exit.
- **Masking only in one command.** Wrong: `show` hides the password, `get` and `export` print it. Right: one `shown` function used everywhere, and secrets left out of exports by default.
