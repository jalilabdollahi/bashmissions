# Debrief: Retry Wrapper

Because `"$@"` can stand for *any* command, a function that takes the command
as its tail arguments becomes a wrapper: it neither knows nor cares what it runs.
This is the "higher-order function" of the shell: the thing you pass is a
command line. A good wrapper is invisible when things work and informative
when they do not.

## What a good wrapper preserves

- **Arguments**: `"$@"` passes "tidewater books" as one word.
- **Output**: stdout of the command flows through untouched; the wrapper's own
  messages go to stderr.
- **Exit status**: after giving up, the last status comes back, so a caller can
  react to 7 differently from 1. Returning a generic 1 would hide that.

## Under the hood

The tricky line is `"$@" || rc=$?`. Under `set -e`, the shell exits when a
command fails, except in places where the status is being tested: the left side
of `||` is one of them, as are `if` conditions and `while` tests. So `||`
both prevents the exit and lets you record why it failed. Resetting `rc=0`
before each run keeps a successful attempt from inheriting the previous
failure.

## When retrying is wrong

Retrying only helps with transient errors. A wrong password or a missing file
will fail identically every time; retrying such commands wastes time, and for
non-idempotent actions (charging a card!) it can do harm. Real wrappers add a
delay with backoff and sometimes an allow-list of retryable statuses.

## In real work

Network calls, package downloads, database connections at boot, cloud APIs
that throttle: all candidates for this wrapper.

## Going further

Another thing a wrapper can add without changing the command: a stopwatch.
Next, a timing wrapper.
