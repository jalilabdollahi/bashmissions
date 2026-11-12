# Debrief: The Log Investigator

Every real incident starts with the same annoyance: the evidence is in several
places and every place speaks a different dialect. The cure is a **canonical
record**. You did not write one clever parser; you wrote three small ones that
all produce the same shape, and then every later step (filtering, sorting,
counting) was written once, against that shape.

A few details were doing quiet work. ISO-style timestamps are zero padded, so
alphabetical order *is* chronological order: that is why the window check and the
sort needed no date arithmetic at all, which is also why the script runs
identically on macOS and Linux. The sort keys (time, file index, line number) make
the merge deterministic, so a report generated twice for the same incident is
byte-for-byte identical, an important property when the report ends up in an
insurance claim. The message is the last field precisely because it is free text
and may contain the separator.

The exit status turned a report into a *signal*: `exit 1` on CRIT lets a pager
script or a CI job react without parsing your output.

In practice this is the core of log shippers, SIEM ingestion and post-mortem
tooling. Going further: the next mission feeds a different kind of history, disk
usage over time, into a projection instead of a timeline.
