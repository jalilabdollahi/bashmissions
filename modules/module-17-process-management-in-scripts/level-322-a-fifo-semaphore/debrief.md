# Debrief: A FIFO Semaphore

## What you learned

A pipe can be a counter. Tokens in the pipe are free seats; `read` takes one
and blocks when there are none; `echo >&3` gives one back. The kernel does the
counting and the waiting for you, atomically, and the loop needs no `running`
variable. This is a **counting semaphore**, and it is the same idea that
sits behind many locks and pools in operating systems.

## Under the hood

`exec 3<> file` opens the file once and attaches it to descriptor 3 for the rest
of the shell's life. Child processes (our background groups) inherit the open
descriptor, so all of them share one pipe. Opening with `<>` on Linux and macOS
succeeds immediately for a FIFO because the process itself counts as both
reader and writer. Deleting the name with `rm` only removes the directory entry;
the pipe exists until the last descriptor closes.

Each token is a newline, and `read` consumes exactly one line, so
consuming and returning tokens never mixes up.

The danger is a lost token: a job that dies before returning it shrinks the pool
for good. In real scripts the return is done in a way that always runs, such
as the unconditional `echo >&3` after the command. A job killed by SIGKILL
still loses its token.

## In real work

Make-style build tools use exactly this "jobserver" design: GNU make passes a
token pipe to its children so that a tree of recursive makes shares one
`-j` limit.

## Going further

That ends the module on processes. You now start work in parallel, limit it,
signal it, shield it, and collect its results. The next module turns to the
building blocks of larger programs: functions.
