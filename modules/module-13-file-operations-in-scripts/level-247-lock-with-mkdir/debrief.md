# Debrief: Lock with mkdir

## What you learned

Mutual exclusion in shell scripts: you cannot safely *look* and then
*act*, because things change in between. You need a single operation that
does both. Creating a directory is such an operation on every file system,
which is why `mkdir` has been the portable lock in shell scripts for decades.

## Under the hood

The check "does this name exist?" and the creation happen inside one kernel
call. The kernel serialises these calls, so out of ten simultaneous
`mkdir`s, exactly one returns success. `-p` would defeat the trick on
purpose: it treats "already exists" as success, so everyone would think they
had the lock.

The `trap ... EXIT` line is registered *after* the lock is taken. A script
that failed to get the lock must not clean up somebody else's lock.

The weak spot is a crash: `kill -9` or a power loss skips the trap and
leaves a stale lock. Real systems add a PID file inside the lock folder and
check whether that process is still alive.

## In real work

Cron jobs that must not overlap, deploy scripts, package installers and
backup runs all use this. Always make the busy message clear and exit with
a non-zero status, so the scheduler knows the run did not happen.

## Going further

A lock keeps two writers apart. A related trick makes a single writer safe:
writing a file so that readers never see it half-finished. Next: atomic writes.
