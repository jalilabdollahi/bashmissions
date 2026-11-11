# Debrief: Load Average Check

Load average is the average number of processes that wanted to run (or were
waiting for the disk) over the last 1, 5 and 15 minutes. A single number tells
you "busy now"; the three together tell you the *story*: 4.10, 3.20, 1.05
means the machine is getting worse, while 0.50, 2.00, 3.00 means a storm has
just passed. That is why the script reports a trend, not only a verdict.

Technically this level is about two Bash techniques that appear in nearly every
monitoring script. First, parameter expansion as a scalpel: `${out##*label}`
discards everything up to the last occurrence of a label, so your parser depends
on one fixed phrase and not on column positions that shift when the uptime is
`3 days` or `3:04`. Second, the limits of Bash arithmetic: `(( ))` handles
integers only, and comparing `10.00` with `1.5` as text would say 10.00 is the
smaller. awk reads both as floating-point numbers.

A third point: a good monitor distrusts its input. If the label vanished
(different locale, a different tool version), the script exits with status 3 and says
so. Exit codes (0 ok, 1 problem, 3 cannot tell) are how cron, a pager
wrapper or the next level's watchdog tell the difference.

Going further: the same parsing skill applies to a file made of
`Key: value` lines, which is exactly what `/proc/meminfo` looks like.
