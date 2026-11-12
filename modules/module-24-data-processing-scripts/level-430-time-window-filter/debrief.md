# Debrief: Time Window Filter

The mental model: **a good data format makes the right operation trivial.**
ISO-8601 was designed so that sorting the text sorts the time. Largest unit
first, fixed widths, one zone: with those three properties, "earlier than" is
alphabetical order. That is why logs, file names and database exports that care
about being processed with plain tools use it, and why `2026-03-04` is a
better file name than `04-03-2026`.

Because of this, a time window needs no date library: two comparisons, and
prefixes act as coarser bounds (a date for "the start of that day"). The window
is half-open, `[from, to)`. That is the convention of ranges everywhere
(array slices, `for` loops, SQL `>= AND <`), and it means consecutive windows
tile the timeline with no gap and no overlap, so no event is counted twice in a
week-by-week report.

The trick has conditions, and a careful script checks them instead of hoping:
the timestamp must have the exact shape, or the comparison can silently give
nonsense (`2026-4-1` sorts after `2026-12-01`). Rejecting and reporting
non-conforming lines keeps the filter honest.

One caution: awk and `[[ ]]` compare numerically if both sides look like
numbers. Timestamps never do, but a bare year `2026` as a bound against a
numeric-looking field would. Know which comparison you are asking for.

Going further: the next level takes rows by two keys at once and builds a table
with totals, moving from filtering to a pivot.
