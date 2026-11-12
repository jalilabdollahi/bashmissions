# Debrief: Run in the Background

## What you learned

A trailing `&` splits your script in two: the shell forks a **child process**
for the command and immediately carries on with the next line. Parent and child
now run side by side. The shell remembers the child's process ID in `$!`, which
is your only handle on that job: later levels use it to wait for it, check it
and stop it.

## Under the hood

`snapshot server &` makes the shell call `fork()`; the child replaces itself with
the `snapshot` program (`exec`), so the PID in `$!` really is the PID of that
program. Only the *most recent* background job is kept in `$!`, which is why you
copy it before starting the next. A background job also has no keyboard input:
its stdin is `/dev/null` in a script, but its output still goes to the same
terminal, so parallel jobs that print can interleave.

When the parent script exits, it does not kill its children. They become
orphans and keep running. That is why you ended with `wait`.

## In real work

Starting slow, independent tasks side by side (backups, health checks,
downloads) is the cheapest speed-up a script can get. The price is that you now
own several processes and must keep track of them.

## Going further

Right now `wait` gives you nothing back. Next you will wait for one specific
job by its PID and read how it ended.
