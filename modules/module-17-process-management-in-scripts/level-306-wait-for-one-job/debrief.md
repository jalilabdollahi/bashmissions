# Debrief: Wait for One Job

## What you learned

`wait PID` is how a parent collects the result of one child. It does two
things: it pauses until that child has ended, and it returns the child's exit
status. Without it the parent can never know if the job worked, because the
job's status is only ever delivered to its parent.

## Under the hood

When a child process ends, the kernel keeps its exit status until the parent
asks for it, a short-lived leftover called a *zombie*. `wait` is the "ask".
Bash also remembers the statuses of jobs it has already reaped, which is
why `wait "$pid"` still returns the right number even if the job finished
long before you called it. A job can also be asked about only once: waiting a
second time for the same PID reports that it is not a child of this shell
(status 127).

The status of `wait PID` is the job's status, not "did wait succeed", so under
`set -e` it can end your script. Catching it with `||` is the standard answer.

## In real work

Every supervisor, deploy script and test runner does this: launch, do
something useful, `wait`, branch on the status. The status is the
contract that tools such as `integrity-check` use to report outcomes.

## Going further

One job is easy. With five jobs you need to keep five PIDs and five
statuses. That is the next level.
