# Debrief: Increment and Decrement

## What you learned

`++` and `--` are the idiomatic way to keep a counter. Combined with a loop,
they let a script answer "how many?" about any stream of input without reading
it into memory.

## Under the hood

`x++` is a *post*-increment: the expression yields the old value and then
bumps the variable. `++x` is the *pre*-increment: bump first, then yield the new
value. When you only care about the side effect, they do the same job.

The part that catches everybody: `(( ))` as a command succeeds if the
result is non-zero and fails if it is zero. So `(( count++ ))` on a counter
that is currently 0 returns status 1. In a script using `set -e`, that
silently ends the run. The cures are `(( ++count ))`, `count=$(( count + 1 ))`,
or `(( count++ )) || true`. An uninitialised variable counts as 0, so the
first increment works, but under `set -u` always assign a starting value.

## In real work

Counting failed logins, lines, retries or errors, and tracking "currently
open" things such as connections or locks.

## Going further

When a counter must jump by more than one, `+=` and `*=` come to the
rescue, and that is exactly the next level.
