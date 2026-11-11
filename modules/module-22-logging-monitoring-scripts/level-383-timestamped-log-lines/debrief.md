# Debrief: Timestamped Log Lines

A log is a diary kept by a program, and a diary entry without a date is nearly
useless. The shape you built, `2026-03-01T10:00:00Z message`, is chosen
on purpose: year first, then month, day, hour, minute, second, in UTC. Such
timestamps sort alphabetically into chronological order, which means plain
`sort`, `grep` and `awk` can already slice a log by time.

`printf '%(format)T'` is a Bash builtin (4.2 and newer). It asks the shell's own
clock code to format an epoch, so a script that writes a thousand log lines
starts zero extra processes. That is the difference between a logger that is
free and one that slows the very job it reports on. The special argument `-1`
means "now", and `-2` means "when this shell started".

Notice the design decision to accept the time as an argument. A function that
can only read the real clock is hard to test. One that can be told the time is
deterministic, which is exactly how this level could check you with fixed
answers.

You will meet this in every service that logs to a file, in cron jobs, and in
the incident timelines people stitch together afterwards, always in UTC because
servers and humans live in many time zones.

Going further: the next level adds a threshold, so a script can say a lot while
debugging and only the important lines in production.
