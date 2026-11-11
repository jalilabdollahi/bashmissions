# Common Mistakes

- **Trusting the pipe.** Wrong: `lanternci "$1" | tee "$1.log"; return $?` returns tee's 0. Right: `status=${PIPESTATUS[0]}` right after the pipe, or `set -o pipefail`.
- **Reading PIPESTATUS late.** Wrong: `echo "[$1] done"` between the pipe and `${PIPESTATUS[0]}` replaces the array. Right: copy it on the line directly after the pipeline.
- **Exiting with the wrong `$?`.** Wrong: `run_stage test; echo "stage failed" >&2; exit $?` exits with echo's 0. Right: `run_stage test || exit $?`.
- **Calling `exit` inside the function.** It works for scripts, but a function that exits cannot be reused by callers that want to recover, for example to retry. Right: `return` the status and let the caller decide.
- **Forgetting to stop.** Wrong: calling `run_stage build`, `run_stage test`, `run_stage ship` in a row with no guards ships after a failed test. Right: each call guarded with `|| exit $?` (or `set -e`).
