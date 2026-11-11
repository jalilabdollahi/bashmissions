# Debrief: Metrics File

Logs record *events*; metrics record *state*: a few numbers that describe the
system right now and can be sampled every fifteen seconds. Prometheus popularised
a very small text format for this, and your script now speaks it. Every metric
has a name, an optional set of labels in braces, and a value; `# HELP` and
`# TYPE` are the documentation and the data type.

The two types you used behave differently. A **counter** is a running total that
resets only when the program restarts, and the monitoring server calculates
*rates* from it ("200 requests per minute"), so a counter must never shrink. A
**gauge** is a snapshot that can move in both directions. Choosing the wrong type
makes graphs lie, and is the commonest mistake in metrics code.

Equally important is how the file is published. Many setups use the node exporter's
*textfile collector*: a folder of `.prom` files that are read on every scrape.
Writing straight into such a file risks a reader seeing half of it. Writing to a
temporary name and calling `mv` works because renaming is a single atomic
step in the file system. The same pattern protects config files, deploy
symlinks and caches.

Notice also that malformed lines are counted, not hidden: a rising "bad lines"
number is itself a signal that something upstream changed.

Going further: next, these numbers turn into something a person can read at a
glance, a status board in the terminal.
