# Debrief: Error Spike Detector

Monitoring rarely cares about single events. It cares about **rates**: how
often something happens per unit of time. A log is a list of events, and the
unit of time is already inside every line, so counting per minute is a matter of
cutting out the right slice of the line and counting duplicates.

`sort | uniq -c` is the shell's group-by-and-count, one of the most useful
five-word pipelines you will ever learn. It works in three moves: *project*
(keep only the grouping key), *sort* (so equal keys become neighbours),
*count* (collapse each run). ISO-style timestamps, year first, make the sorted
order the chronological order, which is why the report comes out in time order
without extra work.

Precision matters in the filter. Matching `ERROR` anywhere in a line counts
messages that merely *talk* about errors; anchoring to the third field counts
what the logger *labelled* as errors. Whenever you filter logs, ask which
part of the line carries the fact you want.

The threshold turns a graph into an alert. In production, you would run this
from cron every few minutes against the tail of the log, and the exit
status (1 means spike) would trigger the alert. Choosing thresholds is
a craft: too low and nobody trusts the alert, too high and you read about the
outage on social media.

Going further: next, the numbers leave your terminal in the format that
monitoring servers such as Prometheus expect.
