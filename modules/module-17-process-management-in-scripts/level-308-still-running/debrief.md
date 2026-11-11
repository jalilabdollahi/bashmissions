# Debrief: Still Running?

## What you learned

Checking and waiting are different questions. `wait` means "block until this
child is done and tell me how it went". `kill -0` means "is this process
there right now?", answered in microseconds and without changing anything.
Together with a short `sleep` it gives you **polling**: a loop that peeks,
rests and peeks again.

## Under the hood

Despite its name, `kill` is just the tool that sends signals; the kernel
call behind it, `kill(pid, sig)`, treats signal 0 specially. Nothing is
delivered, but the kernel still does its error checks: no such process gives
`ESRCH`, no permission gives `EPERM`. Both make `kill -0` fail, so a fail does
not always mean "dead": for a process owned by another user it means "not
yours". For your own children the check is reliable.

PIDs are recycled eventually. A stale PID in an old pid file can point at an
unrelated process, so real tools usually also check the process name.

## In real work

Watchdogs, health scripts and "is the daemon up?" checks lean on
`kill -0 "$(cat /var/run/app.pid)"`. Polling with a retry limit is also how
scripts wait for a port, a file or a service to appear.

## Going further

Sometimes the answer is "yes, still running, and it must stop". Next level:
ending a job on purpose and collecting its status.
