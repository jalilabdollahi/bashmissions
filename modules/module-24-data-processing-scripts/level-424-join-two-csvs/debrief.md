# Debrief: Join Two CSVs

The mental model: **a join is a lookup table plus a stream.** Databases hide
this behind the word JOIN, but the idea is old and small: keep the small side
in memory under its key, walk the big side, and for each row ask "who are you?".
This is called a hash join and it is what many real query engines do.

awk makes the two-file version compact because of `NR` and `FNR`. `FNR == NR`
answers "am I still in the first file?" without any flag variables, and the
`next` at the end of that rule keeps the lookup file from falling through to the
rules meant for the invoices. Because the lookup file is read completely before
the first invoice, order does not matter in either file.

The decisions about edge cases are part of the design, and should be stated:
what if the id is unknown (a visible `UNKNOWN`, not a dropped row), and what if
the lookup side has duplicates (first wins, here). A report that silently drops
unmatched rows is a report that quietly undercounts. Compare this with `join`,
which needs sorted input and discards unmatched lines by default.

Memory is proportional to the lookup file only. The invoices can be gigabytes
long and still stream through.

Going further: the lookup here produced a CSV. The next level produces another
format entirely: JSON, where quoting and escaping decide whether the output is
valid at all.
