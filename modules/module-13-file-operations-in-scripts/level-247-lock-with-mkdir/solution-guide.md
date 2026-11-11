# Walkthrough: Lock with mkdir

## The plan

A lock is just a shared agreement: "if this thing exists, someone is
working". The only hard part is making the *check* and the *claim* a single
step. `mkdir` is that step.

## Why not `if [[ ! -d lock ]]; then mkdir lock`?

Between the test and the `mkdir`, another copy of the script can run its own
test. Both see "no lock", both create it, both proceed: exactly the overlap
we are trying to prevent. This gap is called a race condition.

## Step by step

Plain `mkdir` (no `-p`) asks the kernel to create the folder and fails if it
exists. Only one caller can win, so the exit status *is* the answer:

```bash
mkdir -p run                       # the parent; -p is fine for THIS one
if ! mkdir "$lock" 2>/dev/null; then
  echo "$job is already running (lock: $lock)" >&2
  exit 1
fi
```

`2>/dev/null` hides mkdir's own "File exists" complaint since we print a
better one. Note the loser exits **before** registering the trap: if it
registered first, its cleanup would remove the lock that belongs to the
winner.

For the winner, the trap guarantees release on every path:

```bash
trap 'rmdir "$lock"' EXIT
```

With `set -e`, a failing `run-job` ends the script right there, the trap
fires, the lock disappears, and the exit status of `run-job` becomes ours.
The "finished" line, written after it, never happens: the log records an
honest "started" without a "finished".

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh JOB" >&2
  exit 2
fi
job=$1
lock="run/$job.lock"
mkdir -p run
if ! mkdir "$lock" 2>/dev/null; then
  echo "$job is already running (lock: $lock)" >&2
  exit 1
fi
trap 'rmdir "$lock"' EXIT

echo "$job started" >> run/jobs.log
run-job "$job"
echo "$job finished" >> run/jobs.log
```

## Try it by hand

```bash
mkdir -p run/nightly.lock        # pretend another copy is running
./solution.sh nightly ; echo "exit $?"
rmdir run/nightly.lock
./solution.sh nightly
```

## An alternative

`flock` does this with file locks and also survives crashes more
gracefully, but it is a Linux tool and absent on macOS. The `mkdir` lock
works everywhere. Its weakness: if the script is killed with `kill -9`,
the trap never runs and a stale lock stays behind.
