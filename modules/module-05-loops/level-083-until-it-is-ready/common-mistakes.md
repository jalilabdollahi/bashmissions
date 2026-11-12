# Common Mistakes

- **Reading `until` as "while".** It stops on success, not on failure.
  Wrong: expecting `until replica-status` to run while the replica is ready
  Right: it runs while the probe is NOT ready
- **Putting the test in brackets by habit.** The condition is the command, no `[ ]` needed.
  Wrong: `until [ replica-status ]; do` (tests that a non-empty word exists, which is always true)
  Right: `until replica-status; do`
- **Counting before the first failure.** Incrementing at the top of the body shifts every number.
  Wrong: starting `check=0` and printing before incrementing gives "check 0"
  Right: `check=1` and increment at the end of the body
- **No pause in real life.** Calling a probe in a tight loop hammers the service. Add `sleep` between checks in production scripts.
