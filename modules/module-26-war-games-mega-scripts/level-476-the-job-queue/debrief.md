# Debrief: The Job Queue

Concurrency bugs are the hardest to reproduce, so the cure is to rely on **atomic primitives** and to avoid
inventing your own locking. On a file system, two operations are atomic: renaming a file within a filesystem
and creating a directory that must not already exist. This queue uses nothing else: `mv` to publish a job and
`mkdir` to claim it. No `flock`, no sleeps polling a flag, no race windows. The same trick underlies Maildir, many cron
wrappers and lock files in package managers.

The worker pool shows the Bash way to do parallel work: shell functions started with `&`, results returned through files,
a single `wait`. Printing from the workers directly would produce interleaved, order-dependent output; collecting in
files and reporting in ID order makes the output deterministic. Retrying with a pause (but not after the last attempt) and
parking the final failure with its output attached is the standard shape of a dead-letter directory: failed work is not
lost, it waits where a human can inspect it and `retry` it.

Finally, crash recovery: because the run lock guarantees a single runner, any leftover claim *must* be stale. Reasoning about
what state is possible after a crash, and making the next run repair it, is what separates a script from a service.

Going further: the next mission goes back to integrity. An append-only, tamper-evident audit log.
