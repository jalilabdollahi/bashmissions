# Debrief: Cron Wrapper

The mental model: **an unattended job must be safe to start at any moment, and
leave evidence.** Cron guarantees neither. A wrapper adds mutual exclusion
(only one run at a time), a log (so "what happened at 02:00?" has an answer) and
an honest exit status (so monitoring sees failures).

Why `mkdir` is the lock: creating a directory is a single atomic step in the
filesystem, so check-and-take cannot be split by another process. A test-then-
`touch` has a gap between the two steps that two runs will eventually fall into.

The ownership rule is the subtle part. The cleanup trap must be installed only
after the lock is yours. A skipped run that cleaned up on exit would delete the
running job's lock, and the next run would start a duplicate, the exact failure
the lock exists to prevent.

`trap ... EXIT` is bash's "finally": it runs however the script ends. Signals
terminate a script without running the EXIT trap unless you convert them with
`trap 'exit N' TERM`. A `kill -9` cannot be trapped, so mature wrappers also check
whether the lock is stale, for example by storing a PID inside it.

Going further: the lock guards a run; sometimes the setup itself must also be
safe to repeat. The next level makes a provisioning script idempotent.
