# Debrief: Disk Usage Alert

Monitoring is the art of turning a tool's *human* output into a *decision*. `df`
prints a table for people; you turned it into a yes/no and an exit status that
cron, a pager or another script can act on.

Why `-P`? Plain `df` is allowed to wrap a long device name onto a second line,
which would break any line-by-line parser. The POSIX flag guarantees one
filesystem per line and fixed columns, so `read -r device blocks used avail pct
mount` always lines up. When you parse a tool's output, always ask for its most
machine-friendly mode.

`read` with several variable names splits on whitespace, and the final variable
swallows the remainder, which is why the mount point is last: a mount path with
spaces would still arrive whole. The `%` is just text until you cut it off with
`${pct%\%}`; after that the value is a number and `(( ))` can compare it.

Notice the three outcomes and their exit codes (0 fine, 1 alert, 3 monitor
broken). A monitor that cannot measure must never say "all clear".
Distinguishing "everything is fine" from "I could not look" is a rule you will
keep applying.

Going further: the same recipe, capture the output and split it, works for
`uptime`, and the next level reads the machine's load average.
