# Common Mistakes

- **Letting `set -e` end the wrapper.** Wrong: a bare `"$@"` line exits the script on the first failure, so there is never a second attempt. Right: `"$@" || rc=$?`.
- **Forgetting to `shift`.** Wrong: running `"$@"` with the count still in front tries to execute a command named `3`. Right: `shift` after reading the count.
- **Returning a fixed status.** Wrong: `return 1` after the last attempt hides the command's real status (`retry: giving up` but exit 1 instead of 7). Right: `return "$rc"`.
- **Stale status after a success.** Wrong: not resetting `rc` between attempts, so a later success still looks like the earlier failure. Right: `rc=0` at the top of the loop.
- **Sleeping after the last attempt.** Wrong: sleeping before checking whether attempts are used up makes the failure case slow for nothing. Right: check `attempt >= max` first, then sleep.
