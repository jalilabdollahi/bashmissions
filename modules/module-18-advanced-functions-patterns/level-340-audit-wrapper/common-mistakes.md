# Common Mistakes

- **Logging with `$*` or plain `echo`.** Wrong: `echo "$USER: $* status=$rc"` shows `echo a;b *` and hides the difference between one argument with a space and two arguments. Right: `printf -v words '%q ' "$@"`.
- **Letting a failing command end the run.** Wrong: a bare `"$@"` under `set -e` exits before logging, so the most interesting entry (the failure) is missing. Right: `"$@" || rc=$?`.
- **Truncating the log.** Wrong: `> "$log"` rewrites the file on every command, leaving only the last line. Right: `>> "$log"`.
- **Forgetting the trailing space.** Wrong: logging `$words` directly gives `echo hello status=0` with a doubled space before `status`. Right: `${words% }`.
- **Using `read` without `-a` and then `$line` unquoted.** Wrong: `$line` is split and globbed, so `*` becomes the folder's file names, and the log records those. Right: `read -ra words` and `"${words[@]}"`.
