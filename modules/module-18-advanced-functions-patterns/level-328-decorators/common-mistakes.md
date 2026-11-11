# Common Mistakes

- **Redefining without saving the original.** Wrong: `restart_service() { echo ">>"; restart_service "$@"; }` calls itself forever. Right: copy the old body first (`eval "orig_$(declare -f restart_service)"`) and call `orig_restart_service`.
- **Losing the exit status.** Wrong: ending the wrapper with `echo "<< done"` makes it return 0, hiding the failure. Right: store `rc` and `return "$rc"`.
- **Letting `set -e` kill the wrapper.** Wrong: a bare `orig_fn "$@"` exits the script on failure before the closing line prints. Right: `orig_fn "$@" || rc=$?`.
- **Dropping the arguments.** Wrong: `orig_fn $1` splits or loses extra words. Right: `"$@"`, in both the wrapper and the call to `traced`.
- **Not checking the name.** `declare -f nope` prints nothing and fails; `eval "orig_"` then does nothing useful and the wrapper recurses or errors later. Right: test the status of `declare -f` and stop early.
