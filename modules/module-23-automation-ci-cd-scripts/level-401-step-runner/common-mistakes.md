# Common Mistakes

- **Reading `$?` too late.** Wrong: `bash "$step" || true; if (( $? != 0 ))` always sees 0, because `true` replaced the status. Right: `rc=0; bash "$step" || rc=$?`.
- **Letting `set -e` die silently.** Wrong: a bare `bash "$step"` aborts with no message, so the log never says which step failed. Right: capture the status and print `FAILED at step N`.
- **Always exiting 1.** Wrong: `exit 1` after any failure hides the step's real code. Right: `exit "$rc"` so 127 stays 127.
- **Forgetting that the loop must stop.** Wrong: printing FAILED but not exiting, so later steps (like the deploy) still run. Right: `exit "$rc"` inside the failure branch.
- **Using `$#` after shifting or inside the loop body expecting the total.** Wrong: `shift` in the loop and printing `$#` as TOTAL. Right: save `total=$#` before the loop.
