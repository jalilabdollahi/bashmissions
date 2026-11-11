# Debrief: Reload on HUP

## What you learned

SIGHUP started life as "the terminal hung up". Daemons have no terminal, so
the signal became free and the convention stuck: **HUP means reload your
configuration**. A well-behaved service traps it, re-reads its files and keeps
every connection and in-memory state it has. The operator's command is just
`kill -HUP <pid>`.

## Under the hood

The signal is delivered by the kernel the moment someone calls `kill`, but
bash only runs your trap between commands: after the current command ends.
During a long foreground `sleep` the handler waits, hence the short polling
sleeps in the answer.

Without a trap, HUP's default action is to terminate the process, so the order
"trap first, then let anyone send HUP" is a correctness rule. The same applies to
the first moments of any real daemon.

A handler that is interrupted by the same signal again, or that does
non-trivial work, can leave a half-loaded state. Setting a flag and reloading
from the main loop, or at least reading the whole file into a temporary
variable before swapping, makes reloads safe.

## In real work

`systemctl reload`, `nginx -s reload`, `kill -HUP $(cat /run/app.pid)` and
logrotate's "postrotate" scripts all work this way.

## Going further

Handlers decide what a signal means. Sometimes you want the opposite: a
stretch of code that signals cannot interrupt at all.
