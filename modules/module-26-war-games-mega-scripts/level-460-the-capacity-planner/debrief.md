# Debrief: The Capacity Planner

Monitoring tells you what is happening; **capacity planning tells you when it
becomes a problem**. The method is old and humble: fit a line to the history, extend
it, see where it crosses the limit. Least squares uses every sample, so it ignores
a single odd reading in a way that "last minus first" never could. The real
craft is in the edges: groups with too little data say `NODATA` instead of guessing,
disks that are not growing never divide by zero, and a disk at 96 percent is critical
even if the line is flat.

The calendar functions are the other lesson. Date commands are among the least
portable tools there are, and many production scripts break on the first server that
runs a different OS. Converting to a day count turns every calendar question into
integer arithmetic, and the "March-first" trick removes the leap-year special case
entirely. It is a good habit to remember that most date bugs are really *calendar*
bugs, and numbers do not have them.

The exit codes follow the monitoring-plugin convention (0 OK, 1 WARNING, 2 CRITICAL,
3 UNKNOWN), so this script could be dropped into Nagios, Icinga or a cron wrapper
without change.

Going further: the next mission also reads files full of state, but it asks a different
question: who is on the machine that should not be?
