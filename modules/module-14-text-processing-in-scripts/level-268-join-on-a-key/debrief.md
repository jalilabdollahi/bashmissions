# Debrief: Join on a Key

`join` is the relational idea in a single command: two tables, one shared key,
combined rows. Its design leans on sorting. Because both inputs are in key order,
it needs only one line of each file at a time, so it can join two files that are
far larger than memory. In exchange, it trusts you completely. If the input is
not sorted, GNU join prints a warning and macOS join often says nothing at all,
but in both cases rows silently go missing.

That is why every correct `join` is wrapped in `sort`, and why the two sorts
must agree with join about ordering. The same key must use the same collation
everywhere, which is another reason scripts set `LC_ALL=C` at the top. Sorting
by the key field alone (`-k1,1`) rather than by the whole line prevents
delimiter characters from changing the order.

Where it shows up in real work: attaching names to IDs, matching a list of
servers with their owners, combining an export with a lookup table. The options
you will want next are `-a 1` (keep unmatched rows from file 1, a "left join"),
`-v 1` (print only the unmatched ones) and `-1`/`-2` (choose the key field in
each file).

Going further: instead of combining two files, you may want to know what
differs between them. The next level compares two sorted lists with `comm`.
