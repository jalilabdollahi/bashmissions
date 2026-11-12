# Common Mistakes

- **Using `eval` to read a variable by name.** Wrong: `eval "value=\$$name"` executes anything the name contains. Right: `value=${!name:-}`.
- **Echoing the secret to prove it worked.** Wrong: `echo "$name=$secret"` ends up in the CI log forever. Right: print the length `${#secret}` and the source.
- **Counting the final newline.** Wrong: `wc -c < "$path"` reports 12 for an 11-character token, because the editor added a newline (and the secret would not match what the service expects). Right: `secret=$(<"$path")`, then `${#secret}`.
- **Silently preferring one source.** Wrong: using the file whenever it is set hides a stale `DB_PASSWORD` in the environment. Right: both set means an explicit error.
- **Forgetting `:-` under `set -u`.** Wrong: `${!file_var}` aborts with `unbound variable` when `X_FILE` was never set. Right: `${!file_var:-}`.
