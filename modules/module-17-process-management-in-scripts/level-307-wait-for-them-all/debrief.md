# Debrief: Wait for Them All

## What you learned

Parallel work has two clocks: the order jobs *start* in, which you control,
and the order they *finish* in, which you do not. A reliable script keeps
the two apart. It records the start order (an array of PIDs next to an array
of names) and asks for results in that order. Output printed as jobs finish
would change from run to run; output printed after collecting is stable.

## Under the hood

`wait "$pid"` does not care when the child ended. A child that has finished
stays a zombie, holding its exit status, until its parent collects it, and bash
also remembers the status of every job it reaped for exactly this purpose.
So waiting for job 1 while jobs 2 and 3 have already finished costs nothing.
Total time is the slowest job, not the sum.

Note the difference from a bare `wait`: it waits for everything but returns 0,
so one failure in ten disappears.

## In real work

Fleet backups, multi-host health checks and test suites all use "start all,
collect in order". The summary line plus an exit code lets cron, CI or a
human see at a glance whether anything went wrong.

## Going further

You have been asking "is it done?" by blocking. Next: asking without
blocking, to find out whether a process is still alive.
