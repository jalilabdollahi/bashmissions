# Debrief: Cleanup on Exit

Scripts leave things behind: lock files, half-written outputs, mounted folders,
background jobs. Cleaning up at the bottom of the script only works if the script
reaches the bottom. Add `set -e` and the number of ways to leave multiplies.

`trap 'commands' EXIT` solves that with a different mental model. You do not
sprinkle cleanup across the script; you declare, once, "when this shell exits,
for any reason, run this". Bash fires the EXIT trap on a normal finish, on
`exit N`, on a failure caught by `set -e`, and even when the shell is stopped by
many signals. The script's exit status is unchanged by the trap unless the
trap itself calls `exit`.

Good habits: register the trap right after you acquire the resource, keep the
cleanup idempotent (`rm -f`, not `rm`), and make it a named function so the line
`trap release_lock EXIT` documents itself. Cleanup should be short and should not
fail; a failing cleanup hides the original problem.

In real systems this protects lock files, temporary directories, "maintenance
mode" markers and anything else that must not outlive its owner.

Going further: sometimes you want to know *where* the failure happened before you
exit. The next level uses a different trap, `ERR`, for exactly that.
