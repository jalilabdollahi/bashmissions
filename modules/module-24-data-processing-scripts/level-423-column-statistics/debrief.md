# Debrief: Column Statistics

The mental model: **a statistic is a fold.** You walk the rows once and carry a
small amount of state (a count, a total, the current smallest, the current
largest); at the end the state is the answer. No array of all the values is
needed, so the memory use is constant, and the job works on a ten-line file and
a ten-million-line file in exactly the same way.

Two details separate a toy from a trustworthy report. The first is seeding:
`min` and `max` must start from the first real value, because every fixed start
(0, a huge number) is wrong for some dataset. The second is respecting dirty
data. A cell that is not a number must be counted and left out, not silently
treated as zero: `pending` plus 0 is a lie that pulls the average down. By
printing `skipped=2` next to the figures, the report tells Gus how much he is
allowed to trust it.

Under the hood awk keeps one double-precision number per variable, so sums are
floating point and `%.2f` rounds only the display. For money in a real
accounting system you would count cents as integers; for a quick report this is
fine, as long as the test data does not sit exactly on a rounding tie.

Going further: statistics over a whole column answer "how much overall". The
next levels answer "how much per customer" by connecting two files with a
shared key.
