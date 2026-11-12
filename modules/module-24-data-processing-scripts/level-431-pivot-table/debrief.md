# Debrief: Pivot Table

The mental model: **a pivot table is a group-by whose key has two parts, shown
as a grid.** Each cell is "sum of the measure for this row value and this column
value", and the margins are the same measure summed along one axis. awk's
subscripts make this natural: `cell[$1, $2]` is just a string key made of both
parts (joined with `SUBSEP`, a character that does not occur in normal data),
which is why awk has no real two-dimensional arrays and does not need them.

Three details separate a pivot from a loose pile of numbers. Totals must be
computed from the same data in the same pass, so the margin always equals the
sum of the cells. Missing combinations must be explicit zeros: a blank cell is
ambiguous ("no data" or "zero?"), and a spreadsheet user will treat it
differently. And the names must be ordered, so tomorrow's table lines up with
today's.

Sorting inside awk is a reminder that portable awk is small: no `asort`, no
`PROCINFO`. Insertion sort is twelve lines, plenty fast for the number of
distinct names in any realistic report (it would be slow for millions, where
you would pipe through `sort` instead). The `""` forcing text comparison is
a classic: awk decides numeric or text per value, and names that look like
numbers must not be allowed to choose.

Going further: the next level presents a table for people, not tools, and
generates a Markdown report with a heading, a table and a summary line.
