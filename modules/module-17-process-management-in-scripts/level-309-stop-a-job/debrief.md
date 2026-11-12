# Debrief: Stop a Job

## What you learned

`kill` does not kill, it *sends a signal*. The default signal, SIGTERM, is a
request that the program may handle, for example to flush files before
leaving. Because the program decides how to react, you collect the outcome
with `wait`, and the status tells you what happened: 0 for a clean finish,
its own code if it failed, and 128+N when signal number N ended it.

## Under the hood

Signals are small numbered messages delivered by the kernel. SIGTERM is
15, SIGKILL is 9, SIGINT (Ctrl-C) is 2. When a process dies from a signal,
there is no exit code to report, so the shell invents one: 128 plus the signal
number. That is why a SIGTERMed job shows 143 and a SIGKILLed one shows 137.

`kill` can fail with "No such process" when the target already ended. A
script with `set -e` must expect that, which is why the answer uses it as an
`if` condition.

## In real work

Every restart script, timeout wrapper and cleanup trap uses this pair. The
polite way is SIGTERM first, wait a little, and only then SIGKILL (`kill -9`),
which cannot be caught and gives no chance to clean up. Keep SIGKILL for jobs
that truly ignore a request.

## Going further

You have been starting at most a handful of jobs. Next: a hundred jobs, but
only a few at any one moment.
