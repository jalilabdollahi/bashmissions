# Common Mistakes

- **Exiting inside the handler.** Wrong: `trap 'exit 0' TERM` stops mid-job, so no "finished" line and no `queue.left`. Right: `trap 'stopping=1' TERM` and check the flag between jobs.
- **Never checking the flag.** Setting `stopping=1` is not enough: nothing reads it. Add `if (( stopping )); then break; fi` at the top of the loop.
- **Checking the flag in the middle of a job.** Wrong: `break` right after `kill`-time work skips the "finished" line and loses the job count. Right: check at the start of an iteration.
- **Off-by-one in the slice.** Wrong: `"${jobs[@]:done_count+1}"` skips the next waiting job. Right: `"${jobs[@]:done_count}"`, because indexes start at 0.
- **Forgetting that the flag starts unset.** Without `stopping=0`, `(( stopping ))` is an error under `set -u` and untidy without it.
