# Debrief: Strict Mode

`set -euo pipefail` is the shortest useful contract you can sign with a script:
"if anything surprising happens, stop and tell me." Each of the three letters
closes a different hole. Errexit stops on a failed command, nounset turns an
unset variable from an empty string into an error, and pipefail refuses to let a
healthy last stage cover for a crashed first stage.

Without it the failures are not loud, they are plausible. The stats file is
empty and the report says "archived". The backup path is `/dory` and the copy
goes somewhere nobody looks. Strict mode converts those silent wrong results into
early, visible, cheap stops.

It is not a free lunch. You already know the exceptions of `-e` (conditions and
`&&` lists), `-u` forces explicit defaults like `${var:-}`, and pipefail makes
`grep` returning 1 count as a failure. Many teams still adopt it as the default,
and then write `|| true` or an `if` in the few places where a non-zero status is
expected.

It also has no memory of what it already did: when the script stops at step three,
steps one and two have already changed the world. That half-done state is the
next problem.

Going further: the next level adds a cleanup that runs whenever the script
ends, however it ends: `trap ... EXIT`.
