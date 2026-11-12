# Common Mistakes

- **Exponential with `1 << n` and no limit.** For large `n` the value wraps around to zero or a negative number, and the loop retries instantly or sleeps for "-9223372036854775808" seconds. Double step by step and clamp.
- **Waiting after the last attempt.** With ATTEMPTS=3 there are only two waits. Sleeping once more and then giving up wastes time and makes `plan` disagree with `run`.
- **Retrying everything.** Exit 127 (command not found) and 126 (not executable) never get better. Retrying them delays the error message by minutes.
- **Letting `set -e` end the wrapper.** `"$@"` on its own line exits the wrapper on the first failure, before the retry logic runs. Capture the status with `status=0; "$@" || status=$?`.
- **Swallowing the exit status.** Exiting 1 for every failure hides whether the command timed out or was refused. Return the command's own status.
- **Mixing messages into stdout.** Retry noise on stdout corrupts the output of the wrapped command in pipelines. Print wrapper messages to stderr.
- **No total budget.** Four attempts of 8, 16, 32 and 64 seconds may exceed what the caller can afford. A budget lets the wrapper give up early.
