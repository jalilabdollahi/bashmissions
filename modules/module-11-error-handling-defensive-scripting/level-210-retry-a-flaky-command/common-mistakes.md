# Common Mistakes

- **No ceiling.** Wrong: `until lanternpush; do sleep 1; done` runs forever when the service is down. Right: count the attempts and stop at MAX.
- **Off-by-one in the loop.** Wrong: `attempt < max` with a start of 1 runs MAX-1 attempts. Right: `attempt <= max`, or count from 0 with `<`.
- **Sleeping after the last failure.** The script waits for nothing and then reports defeat. Right: `if (( attempt < max )); then sleep 0.1; fi`.
- **Retrying inside `set -e` without a condition.** Wrong: a bare `lanternpush` line aborts the script on the first failure. Right: `if lanternpush; then ...`.
- **Losing the last status.** Wrong: ending the script after the loop with `exit $?` where `$?` is that of `sleep` or a test. Right: an explicit `exit 1` after the giving-up message.
