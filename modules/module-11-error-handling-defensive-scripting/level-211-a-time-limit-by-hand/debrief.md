# Debrief: A Time Limit by Hand

Every blocking command has a failure mode where it never returns. The shell cannot
interrupt it from the inside, so a time limit always has the same architecture:
something else keeps the clock. Here that is your script. It launches the work with
`&`, takes the PID from `$!`, sleeps for the allowed time and then makes a decision.

Three primitives carry the whole idea. `kill -0 PID` is an existence test: no signal
is sent, and the status says whether the process is alive. `kill PID` sends TERM,
the polite "please stop", which a tool such as your scan can clean up after (compare
the signal levels earlier in this module). `wait PID` blocks until the job is gone
and returns its exit status, which is the only way to learn how a background job
ended.

Choose your exit codes deliberately. 124 mirrors GNU `timeout`, so callers already
know what it means; passing through the scan's own status for ordinary failures
keeps the meaningful-exit-codes contract intact.

Production versions add a second stage: after TERM, wait a few seconds and send
`kill -9` if the process is stubborn, and they kill the whole process group when the
job spawns children. Those are refinements of the same pattern.

Going further: before running anything you can find out up front whether the tools
exist. The next level checks all dependencies at once.
