# Debrief: Graceful Shutdown

SIGTERM is the polite signal. Service managers, container runtimes and the
`kill` command all use it for "please stop". It comes with an implied deadline:
if you are still running after a grace period, the next signal is SIGKILL, which
cannot be caught. So the right response is quick but orderly.

The key design idea is to separate *noticing* from *acting*. A signal can arrive
at any moment, including the middle of a job, and a handler that did real work
there (closing files, exiting) would break the invariants the main code relies
on. Setting a flag is the smallest possible thing, and the main loop acts on it at
a safe point of its own choosing. The same pattern is used in daemons written in
every language.

Compare with Ctrl-C in the previous level: there the handler itself saved and
exited, because the work was a simple counter. Here each job must complete, so the
exit is deferred. Choose between them by asking "is it safe to stop right now?".

Also think about what the next run needs. The `queue.left` file turns a shutdown
from a loss into a handoff.

Going further: scripts often create scratch files that must disappear on every
path out. The next level combines mktemp and traps for that.
