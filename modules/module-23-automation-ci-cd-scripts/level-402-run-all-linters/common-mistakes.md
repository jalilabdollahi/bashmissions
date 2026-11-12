# Common Mistakes

- **Letting `set -e` stop the loop.** Wrong: `"$linter" -q "$@"` on its own line; the first red linter ends the script and the other two never run. Right: `"$linter" -q "$@" || rc=$?`.
- **Reading `$?` after another command.** Wrong: `"$linter" -q "$@" || true; echo "exit $?"` always prints 0. Right: capture `rc=$?` in the `||` branch.
- **Joining the array with `@`.** Wrong: `echo "lint failed: ${failed[@]}" >&2` inside a longer string can split into separate words. Right: `"${failed[*]}"` when you want one space-joined string.
- **Unquoted file list.** Wrong: `$linter -q $*` splits `release notes.md` into two files. Right: `"$linter" -q "$@"`.
- **Deciding inside the loop.** Wrong: `exit 1` as soon as one linter fails, which is level 401 again. Right: record, and exit once after all three ran.
