# Common Mistakes

- **Forgetting `declare -A`.** Without it `commands=([status]=cmd_status)` makes an ordinary indexed array, and every text key is read as arithmetic: the keys collapse onto index 0 and lookups silently return the wrong function. Right: `declare -A commands=(...)`.
- **Looking up a missing key under `set -u`.** Wrong: `fn=${commands[$name]}` aborts with "unbound variable" for an unknown command. Right: `fn=${commands[$name]:-}`, then test for empty.
- **Not shifting before the call.** Wrong: `"$fn" "$@"` without `shift` hands the command name to the function as `$1`, so `status marlin` prints "status: running". Right: `name=$1; shift` first.
- **Leaving the function name unquoted.** `$fn "$@"` works until a value contains a space or glob character. Right: `"$fn" "$@"`.
- **Calling the table instead of the function.** `"${commands[$name]}"` is fine, but `commands[$name] "$@"` is not a call at all; Bash looks for a command literally named `commands[status]`.
